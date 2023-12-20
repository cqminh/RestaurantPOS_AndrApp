import 'dart:developer';

import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/repository/branch_record.dart';

class BranchRepository extends OdooRepository<BranchRecord> {
  @override
  // ignore: overridden_fields
  final String modelName = 'restaurant.branch';
  BranchRepository(OdooEnvironment env) : super(env);

  @override
  BranchRecord createRecordFromJson(Map<String, dynamic> json) {
    return BranchRecord.fromJson(json);
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
          'fields': BranchRecord.oFields,
          // hiện tại chỉ có một Branch
          // 'limit': 1,
        },
      });
      log("Branch");
      return res;
    } catch (e) {
      log("$e", name: "branch er");
      return [];
    }
  }
}
