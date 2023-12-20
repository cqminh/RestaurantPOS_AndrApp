import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/common/config/config.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_exceptions.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_session.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/controllers/main_controller.dart';

import '../../res_company/repository/company_repos.dart';
import 'user_record.dart';

class UserRepository extends OdooRepository<User> {
  @override
  final String modelName = 'res.users';

  @override
  int remoteRecordsCount = 1;

  UserRepository(OdooEnvironment odoo) : super(odoo) {
    env.orpc.sessionStream.listen(sessionChanged);
  }

  Future<int> checkSession() async {
    int result = 0;
    try {
      await env.orpc.checkSession().timeout(const Duration(seconds: 10));
      unawaited(fetchRecords());
      result = 1;
    } catch (e) {
      if (e is OdooSessionExpiredException) {
        result = 2;
        log("Hết phiên đăng nhập!", name: "checkLogin");
      } else {
        result = 0;
        log("$e", name: "checkSession");
      }
    }
    return result;
  }

  Future<int> authenticateUser({
    required String login,
    required String password,
  }) async {
    int result = 0;
    try {
      log('Authenticating user: $login');
      OdooSession odooSession = await env.orpc
          .authenticate(env.dbName, login, password)
          .timeout(const Duration(seconds: 10));
      log('Authenticating Session: $odooSession');
      Get.find<MainController>().cache.put(Config.cacheSessionKey, odooSession);

      await fetchRecords();
      await CompanyRepository(env).fetchRecords();
      result = 1;
    } on OdooException  {
      
      log("OdooException", name: "authenticateUser");
      result = 0;
      if (recordStreamActive) {
        recordStreamController.addError('Unable to Login');
      }
    } catch (e) {
      if (e is TimeoutException) {
        result = 2;
      }
      if (recordStreamActive) {
        recordStreamController.addError('Network Error');
      }
    }
    return result;
  }

  void logOutUser() {
    if (latestRecords.isNotEmpty) {
      log('Logging out user `${latestRecords[0].login}`',
          name: "user_repository");
      clearCaches();
      env.orpc.destroySession().then((value) => clearRecords());
    }
  }

  void sessionChanged(OdooSession sessionId) {
    if (sessionId.id == '') {
      logOutUser();
    }
  }

  @override
  void clearRecords() {
    latestRecords = [User.publicUser()];
    if (recordStreamActive) {
      recordStreamController.add(latestRecords);
    }
  }

  @override
  User createRecordFromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

  User get userLogin {
    return records[0];
  }

  @override
  Future<List<dynamic>> searchRead() async {
    var publicUserJson = User.publicUser().toJson();
    if (!isAuthenticated) {
      return [publicUserJson];
    }
    try {
      // final userId = env.orpc.sessionId!.userId;
      List<dynamic> res = await env.orpc.callKw({
        'model': modelName,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          // 'context': {'bin_size': true},
          'domain': [
            // ['id', '=', userId]
          ],
          'fields': User.oFields,
        },
      });
      // String avatarBinary = '';
      if (res.length == 1) {
        //avatarBinary = res[0]['image'] ?? "";
        //
        // final imageField = env.orpc.sessionId!.serverVersionInt >= 13
        //     ? 'image_128'
        //     : 'image_small';
        // var unique = res[0]['__last_update'] as String;
        // unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
        // avatarUrl = env.orpc.baseURL +
        //     "/web/image?model=$modelName&field=$imageField&id=$userId&unique=$unique";
        // res[0]['image_small'] = avatarUrl;
      } else {
        res.add(publicUserJson);
      }
      return res;
    } on OdooSessionExpiredException {
      log("OdooSessionExpiredException", name: "searchRead User");
      return [publicUserJson];
    } catch (e) {
      log("$e", name: "searchRead User");
      return [];
    }
  }
}