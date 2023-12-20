// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Product/product_template/repository/product_template_record.dart';

class ProductTemplateRepository extends OdooRepository<ProductTemplateRecord> {
  @override
  final String modelName = 'product.template';
  ProductTemplateRepository(OdooEnvironment env) : super(env);

  @override
  ProductTemplateRecord createRecordFromJson(Map<String, dynamic> json) {
    return ProductTemplateRecord.fromJson(json);
  }

  @override
  List<dynamic> domain = [
    ['active', '=', true],
    ['sale_ok', '=', true],
    ['available_in_pos', '=', true],
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
          'fields': ProductTemplateRecord.oFields,
        },
      });
      log("product");
      return res;
    } catch (e) {
      log("$e", name: "product template err");
      return [];
    }
  }
}