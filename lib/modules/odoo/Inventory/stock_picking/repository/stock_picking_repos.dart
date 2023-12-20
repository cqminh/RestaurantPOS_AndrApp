// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Inventory/stock_picking/repository/stock_picking_record.dart';

class StockPickingRepository extends OdooRepository<StockPickingRecord> {
  @override
  final String modelName = 'stock.picking';
  StockPickingRepository(OdooEnvironment env) : super(env);

  @override
  StockPickingRecord createRecordFromJson(Map<String, dynamic> json) {
    return StockPickingRecord.fromJson(json);
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
          'fields': StockPickingRecord.oFields,
        },
      });
      log("stock picking");
      return res;
    } catch (e) {
      log("$e", name: "stock_picking err");
      return [];
    }
  }

  Future<void> valiDate(int id) async {
    try {
      dynamic res = await env.orpc.callKw({
        'model': modelName,
        'method': 'validate_for_hotel_restaurant',
        'args': [id],
        'kwargs': {},
      });
      log("valiDate");
      return res;
    } catch (e) {
      log("$e", name: "validate stock picking err");
    }
  }

  Future<void> valiDateReturn(int id) async {
    try {
      dynamic res = await env.orpc.callKw({
        'model': modelName,
        'method': 'validate_return_for_hotel_restaurant',
        'args': [id],
        'kwargs': {},
      });
      log("valiDate Return");
      return res;
    } catch (e) {
      log("$e", name: "validate return stock picking err");
    }
  }
}