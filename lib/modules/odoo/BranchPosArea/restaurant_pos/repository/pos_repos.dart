// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/repository/pos_record.dart';

class PosRepository extends OdooRepository<PosRecord> {
  @override
  final String modelName = 'restaurant.pos';
  PosRepository(OdooEnvironment env) : super(env);

  @override
  PosRecord createRecordFromJson(Map<String, dynamic> json) {
    return PosRecord.fromJson(json);
  }

  @override
  Future<List<dynamic>> searchRead() async {
    try {
      List<dynamic> res = await env.orpc.callKw({
        'model': modelName,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': domain,
          'fields': PosRecord.oFields,
        },
      });
      log("pos");
      return res;
    } catch (e) {
      log("$e", name: "pos khanhsnef");
      return [];
    }
  }
}