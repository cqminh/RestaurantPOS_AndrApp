// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_record.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_repos.dart';

class SaleOrderRepository extends OdooRepository<SaleOrderRecord> {
  @override
  final String modelName = 'sale.order';
  SaleOrderRepository(OdooEnvironment env) : super(env);

  @override
  SaleOrderRecord createRecordFromJson(Map<String, dynamic> json) {
    return SaleOrderRecord.fromJson(json);
  }

  @override
  List<dynamic> domain = [
    '&',
    // '|',
    [
      'table_id',
      'not in',
      ['None', 'False']
    ],
    [
      'state',
      'in',
      [
        'sale',
      ]
    ]
  ];

  @override
  Future<List<dynamic>> searchRead() async {
    // chú ý nên kiểm tra domain trước khi search_read để tránh domain truyền vào bị thay thế bởi domain cũ
    try {
      List<dynamic> res = await env.orpc.callKw({
        'model': modelName,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': domain,
          'fields': SaleOrderRecord.oFields,
        },
      });
      log("sale oder ${res.length}");
      return res;
    } catch (e) {
      log("$e", name: "sale order err");
      return [];
    }
  }

  Future<void> confirmOrder(int id) async {
    try {
      log("confirm start");
      dynamic res = await env.orpc.callKw({
        'model': modelName,
        'method': 'confirm_order',
        'args': [id],
        'kwargs': {},
      });
      log("confirm end");
      return res;
    } catch (e) {
      log("$e", name: "confirm sale order err");
    }
  }

  Future<void> lockRestaurantOrder(int id) async {
    try {
      dynamic res = await env.orpc.callKw({
        'model': modelName,
        'method': 'lock_restaurant_order',
        'args': [
          id
          // {'state_folio': state}
        ],
        'kwargs': {},
      });
      log("lock restaurant");
      return res;
    } catch (e) {
      log("$e", name: "lock sale order err");
    }
  }

  Future<void> createInvoice(int id, String? paymentId) async {
    try {
      if (paymentId != null) {
        dynamic res = await env.orpc.callKw({
          'model': modelName,
          'method': 'invoice_create_and_validate_restaurant',
          'args': [
            id,
            {'account_payment_id': paymentId}
          ],
          'kwargs': {},
        });
        log("create invoice account_payment_id $paymentId");
        return res;
      } else {
        dynamic res = await env.orpc.callKw({
          'model': modelName,
          'method': 'invoice_create_and_validate_restaurant',
          'args': [
            id,
          ],
          'kwargs': {},
        });
        log("create invoice");
        return res;
      }
    } catch (e) {
      log("$e", name: "create invoice err");
    }
  }

  Future<List<dynamic>> getPayments(int id) async {
    try {
      dynamic res = await env.orpc.callKw({
        'model': modelName,
        'method': 'get_payments',
        'args': [
          id,
        ],
        'kwargs': {},
      });
      // log("getPayments");
      return res;
    } catch (e) {
      log("$e", name: "get payment err");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> editLine(
      {int? id, List<SaleOrderLineRecord>? lines}) async {
    List<Map<String, dynamic>> retur = [];
    try {
      List<List<dynamic>> args = [];
      for (SaleOrderLineRecord line in lines!) {
        var values = <String, dynamic>{};
        int id = 0;
        if (line.id > 0) {
          id = line.id;
          env.of<SaleOrderLineRepository>().domain = [
            ['id', '=', line.id]
          ];
          await env.of<SaleOrderLineRepository>().fetchRecords();
          final oldRecord = env
              .of<SaleOrderLineRepository>()
              .latestRecords
              .firstWhere((element) => element.id == line.id,
                  orElse: () => line);
          // Determine what fields were changed
          final oldRecordJson = oldRecord.toVals();
          final newRecordJson = line.toVals();

          for (var k in newRecordJson.keys) {
            if (oldRecordJson[k] != newRecordJson[k]) {
              values[k] = newRecordJson[k];
            }
          }
        } else {
          values = line.toVals();
          values.remove('id');
        }
        List<dynamic> item = [id > 0 ? 1 : 0, id, values];
        values['id'] = id;
        retur.add(values);

        args.add(item);
      }

      await env.orpc.callKw({
        'model': modelName,
        'method': 'edit_line',
        'args': [id, args], // Truyền danh sách các đối số
        'kwargs': {},
      });

      log("Edit Line");
    } catch (e) {
      log("$e", name: "error edit line");
    }
    return retur;
  }
}
