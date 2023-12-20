// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Product/pos_category/repository/category_record.dart';

class PosCategoryRepository extends OdooRepository<PosCategoryRecord> {
  @override
  final String modelName = 'pos.category';
  PosCategoryRepository(OdooEnvironment env) : super(env);

  @override
  PosCategoryRecord createRecordFromJson(Map<String, dynamic> json) {
    return PosCategoryRecord.fromJson(json);
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
          'fields': PosCategoryRecord.oFields,
          'order': 'sequence ASC',
        },
      });
      log("pos caterogy");
      return res;
    } catch (e) {
      log("$e", name: "pos category err");
      return [];
    }
  }
}