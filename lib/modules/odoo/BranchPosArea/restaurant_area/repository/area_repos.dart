// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/repository/area_record.dart';

class AreaRepository extends OdooRepository<AreaRecord> {
  @override
  final String modelName = 'restaurant.area';
  AreaRepository(OdooEnvironment env) : super(env);

  @override
  AreaRecord createRecordFromJson(Map<String, dynamic> json) {
    return AreaRecord.fromJson(json);
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
          'fields': AreaRecord.oFields,
        },
      });

      log("area");
      return res;
    } catch (e) {
      log("$e", name: "area err");
      return [];
    }
  }
}