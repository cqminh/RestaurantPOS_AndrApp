// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Inventory/stock_move/repository/stock_move_record.dart';

class StockMoveRepository extends OdooRepository<StockMoveRecord> {
  @override
  final String modelName = 'stock.move';
  StockMoveRepository(OdooEnvironment env) : super(env);

  @override
  StockMoveRecord createRecordFromJson(Map<String, dynamic> json) {
    return StockMoveRecord.fromJson(json);
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
          'fields': StockMoveRecord.oFields,
        },
      });
      log("stock move");
      return res;
    } catch (e) {
      log("$e", name: "stock move err");
      return [];
    }
  }
}