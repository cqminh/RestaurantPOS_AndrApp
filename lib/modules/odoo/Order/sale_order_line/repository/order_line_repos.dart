// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';

class SaleOrderLineRepository extends OdooRepository<SaleOrderLineRecord> {
  @override
  final String modelName = 'sale.order.line';
  SaleOrderLineRepository(OdooEnvironment env) : super(env);

  @override
  SaleOrderLineRecord createRecordFromJson(Map<String, dynamic> json) {
    return SaleOrderLineRecord.fromJson(json);
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
          'fields': SaleOrderLineRecord.oFields,
        },
      });
      log("sale oder line");
      return res;
    } catch (e) {
      log("$e", name: "sale order line err");
      return [];
    }
  }
}