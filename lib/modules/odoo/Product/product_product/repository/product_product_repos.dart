// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Product/product_product/repository/product_product_record.dart';

class ProductProductRepository extends OdooRepository<ProductProductRecord> {
  @override
  final String modelName = 'product.product';
  ProductProductRepository(OdooEnvironment env) : super(env);

  @override
  ProductProductRecord createRecordFromJson(Map<String, dynamic> json) {
    return ProductProductRecord.fromJson(json);
  }

  Future<dynamic> nameGet(int id) async {
    try {
      dynamic res = await env.orpc.callKw({
        'model': modelName,
        'method': 'name_get',
        'args': [id],
        'kwargs': {},
      });
      // log("name get $res");
      return res;
    } catch (e) {
      log("$e", name: "get name product_product err");
    }
  }

  @override
  List<dynamic> domain = [
    ['active', '=', true]
  ];
  @override
  Future<List<dynamic>> searchRead() async {
    try {
      List<dynamic> res = await env.orpc.callKw({
        'model': modelName,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': domain,
          'fields': ProductProductRecord.oFields,
        },
      });
      log("product product");
      return res;
    } catch (e) {
      log("$e", name: "product_product err");
      return [];
    }
  }
}
