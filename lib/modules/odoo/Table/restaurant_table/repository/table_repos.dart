// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';

class TableRepository extends OdooRepository<TableRecord> {
  @override
  final String modelName = 'restaurant.table';
  TableRepository(OdooEnvironment env) : super(env);

  @override
  TableRecord createRecordFromJson(Map<String, dynamic> json) {
    return TableRecord.fromJson(json);
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
          'fields': TableRecord.oFields,
        },
      });
      log("table");
      return res;
    } catch (e) {
      log("$e", name: "table err");
      return [];
    }
  }
}