// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/Customer/res_partner/repository/partner_record.dart';

class ResPartnerRepository extends OdooRepository<ResPartnerRecord> {
  @override
  final String modelName = 'res.partner';
  ResPartnerRepository(OdooEnvironment env) : super(env);
  
  @override
  List<dynamic> domain = [
    ['type', '=', 'contact'],
    ['parent_id', '=', false],
    // ['customer', '=', true],
    ['active', '=', true],
  ];

  @override
  ResPartnerRecord createRecordFromJson(Map<String, dynamic> json) {
    return ResPartnerRecord.fromJson(json);
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
          'fields': ResPartnerRecord.oFields,
        },
      });
      log("partner");
      return res;
    } catch (e) {
      log("$e", name: "partner err");
      return [];
    }
  }
}