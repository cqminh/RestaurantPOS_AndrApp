import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:mutex/mutex.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_client.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_exceptions.dart';
import 'package:test/common/third_party/OdooRepository/src/kv_store.dart';

//import 'package:pedantic/pedantic.dart';
import 'network_connection_state.dart';
import 'odoo_id.dart';
import 'odoo_repository.dart';
import 'odoo_rpc_call.dart';

class OdooEnvironment {
  /// Odoo RPC client
  late OdooClient orpc;

  /// Database name to connect to.
  late final String dbName;

  // Key-value cache client
  late OdooKv cache;

  /// Tracks current network state: online or offline
  late NetConnState netConnectivity;

  // Holds lock to protect RPC Calls queue
  late final ReadWriteMutex callsLock;

  /// Only debug messages
  late Logger logger;

  /// Holds a list of Odoo Repositories
  final _registry = <OdooRepository>[];
  final models = <String, OdooRepository>{};

  OdooEnvironment(this.orpc, this.dbName, this.cache, this.netConnectivity)
      : callsLock = ReadWriteMutex(),
        logger = Logger() {
    orpc.loginStream.listen(loginStateChanged);
    netConnectivity.onNetConnChanged.listen(onNetworkConnChanged);
    // check if our session is valid for database
    if (orpc.sessionId != null && orpc.sessionId!.dbName != dbName) {
      orpc.destroySession();
    }
  }

  bool get isAuthenticated =>
      orpc.sessionId != null && orpc.sessionId?.id != '';

  /// Adds instance of Odoo Repository to registry
  T add<T extends OdooRepository>(T repo) {
    if (!_registry.contains(repo)) {
      _registry.add(repo);
      models[repo.modelName] = repo;
    }
    return repo;
  }

  /// Returns Odoo Repository of given type.
  /// Example:  [of<UserRepository>()]
  T of<T extends OdooRepository>() {
    for (var repo in _registry) {
      if (repo is T) {
        return repo;
      }
    }
    throw Exception('Repo of type $T not found');
  }

  /// Unique identifier of remote Odoo instance
  String get serverUuid {
    if (!isAuthenticated) {
      throw OdooException('Not Authenticated');
    }
    return sha1
        .convert(utf8.encode('${orpc.baseURL}${orpc.sessionId!.dbName}'))
        .toString();
  }

  /// Pending Calls keys for all Odoo instances start with
  final String pendingCallsPrefix = 'OdooRpcPendingCalls';

  /// Unique key per odoo instance
  String get pendingCallsKey => '$pendingCallsPrefix:$serverUuid';

  /// Unprotected by Mutex.
  /// Must be used only inside protected closures.
  List<OdooRpcCall> _getPendingCalls() {
    if (!isAuthenticated) {
      return <OdooRpcCall>[];
    }
    return List<OdooRpcCall>.from(
        cache.get(pendingCallsKey, defaultValue: <OdooRpcCall>[]));
  }

  /// Returns list of calls that has to be done when online
  Future<List<OdooRpcCall>> get pendingCalls async {
    return await callsLock
        .protectRead<List<OdooRpcCall>>(() async => _getPendingCalls());
  }

  /// Puts [rpcCall] to calls queue that will be processed when online
  Future<dynamic> queueCall(OdooRpcCall call, {bool awaited = false}) async {
    dynamic res;
    var calls = await pendingCalls;
    await callsLock.protectWrite(() async {
      calls.add(call);
      await cache.put(pendingCallsKey, calls);
    });
    if (await netConnectivity.checkNetConn() == netConnState.online) {
      if (awaited) {
        await _processCallQueue().then((result) {
          // Xử lý kết quả trả về
          // log("queueCall id: $result");
          res = result;
        }).catchError((error) {
          // Xử lý lỗi
          log("lỗi queueCall Khánh nè $error");
        });
      }
      unawaited(_processCallQueue());
    }
    return res;
  }

  /// Executes rpc call
  Future<dynamic> executeCall(OdooRpcCall call) async {
    var executedCalls = <OdooRpcCall>[];
    logger.d('call key ${call.cacheKey}');
    final params = {
      'model': call.modelName,
      'method': call.method,
      'args':
          (call.args is List && call.args.isNotEmpty) ? call.args : [call.args],
      'kwargs': call.kwargs,
    };

    /// Convert [params] to JSON and back to Map
    /// using dedicated coverter that will replace
    /// [OdooId] instance with real [id] if it is possible.
    final rawParams = json.encode(params, toEncodable: (value) {
      if (value is OdooId) {
        // replace fake id with real one
        return models[value.odooModel]!.newIdToId(value.odooId);
      }
      return value;
    });

    final res = await orpc.callKw(json.decode(rawParams));

    if (call.method == 'create') {
      // store mapping between real and fake id
      await models[call.modelName]!.setNewIdMapping(
          newId: call.recordId, realId: res is List ? res[0] : res);
    }

    logger.d(res.toString());
    executedCalls.add(call);
    // log("TKK - id record: $res");
    return res;
  }

  Future<dynamic> _processCallQueue() async {
    dynamic res;
    if (!isAuthenticated) {
      return;
    }

    var modelsToUpdate = <String>[];

    await callsLock.protectWrite(() async {
      var calls = _getPendingCalls();
      var processedIndex = 0;
      for (var call in calls) {
        try {
          await executeCall(call).then((result) {
            // Xử lý kết quả trả về
            res = result;
            // log("_processCallQueue id: $res");
          }).catchError((error) {
            // Xử lý lỗi
            log("lỗi _processCallQueue Khánh nè $error");
          });

          processedIndex += 1;
          // if model's call was processed it has to be updated
          if (!modelsToUpdate.contains(call.modelName)) {
            modelsToUpdate.add(call.modelName);
          }
        } catch (e) {
          logger.d(e.toString());
          // skip executing on first error as next calls may
          // depend on result of current call.
          break;
        }
      }
      // store calls that were not processed
      await cache.put(pendingCallsKey, calls.sublist(processedIndex));
    });
    for (var model in modelsToUpdate) {
      final repo = models[model];
      if (repo != null) {
        await repo.fetchRecords();
      }
    }
    return res;
  }

  /// Called when going online/offline
  void onNetworkConnChanged(netConnState netState) async {
    if (netState == netConnState.online) {
      await _processCallQueue();
      for (var repo in _registry) {
        await repo.fetchRecords();
      }
    }
  }

  Future<void> loginStateChanged(OdooLoginEvent event) async {
    if (event == OdooLoginEvent.loggedIn) {
      await _processCallQueue();
      //Exception has occurred.
      //ConcurrentModificationError (Concurrent modification during iteration: Instance(length:20) of '_GrowableList'.)
      for (var repo in _registry) {
        await repo.fetchRecords();
      }
    }
    if (event == OdooLoginEvent.loggedOut) {
      for (var repo in _registry) {
        // send empty list of records without deleting them from cache
        repo.clearRecords();
      }
    }
  }
}
