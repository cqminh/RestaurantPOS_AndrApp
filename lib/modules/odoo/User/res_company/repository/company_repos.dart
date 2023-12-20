import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_client.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_exceptions.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_repository.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/User/res_company/repository/company_record.dart';
import 'package:test/modules/odoo/User/res_user/repository/user_record.dart';
import 'package:test/modules/odoo/User/res_user/repository/user_repos.dart';

class CompanyRepository extends OdooRepository<Company> {
  CompanyRepository(OdooEnvironment env) : super(env);

  @override
  final String modelName = "res.company";

  @override
  List<Company> get records {
    if (!isAuthenticated) {
      latestRecords = [Company.initCompany()];
      return latestRecords;
    }
    var cachedUsers = super.records;
    if (cachedUsers.isEmpty) {
      cachedUsers.add(Company.initCompany());
      latestRecords = cachedUsers;
    }
    return cachedUsers;
  }

  @override
  Company createRecordFromJson(Map<String, dynamic> json) {
    return Company.fromJson(json);
  }

  @override
  Future<List<dynamic>> searchRead() async {
    Map<String, dynamic> initCompanyJson = Company.initCompany().toJson();
    if (!isAuthenticated) {
      return [initCompanyJson];
    }
    try {
      UserRepository userRepository =
          Get.find<MainController>().env.of<UserRepository>();
      List<dynamic>? companyIds = userRepository.userLogin.companyIds;
      List<int> companyIdsGenerate =
          List.generate(companyIds == null ? 0 : companyIds.length, (index) {
        return companyIds![index];
      });

      List<dynamic> res = await env.orpc.callKw({
        'model': modelName,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', companyIdsGenerate]
          ],
          'fields': Company.oFields,
        },
      });
      if (res.isEmpty) {
        res.add(initCompanyJson);
      }
      return res;
    } on OdooSessionExpiredException {
      log("OdooSessionExpiredException", name: "company_repo - searchRead");
      return [initCompanyJson];
    } catch (e) {
      log(e.toString(), name: "company_repo - searchRead");
      return [];
    }
  }

  /// - `0` Lỗi
  /// - `1` Thành công
  /// - `2` Lỗi không xác thực
  Future<int> changeCompany(int id) async {
    int result = 0;
    OdooClient odooClient = Get.find<MainController>().env.orpc;
    if (!isAuthenticated) {
      log("Không có user", name: "USER SERVICE - changeCompany");
      result = 2;
      return result;
    }
    User user = Get.find<HomeController>().user.value;
    try {
      await odooClient.checkSession();
      // lấy thông tin của người đăng nhập
      await odooClient.callKw({
        'model': 'res.users',
        'method': 'write',
        'args': [
          user.id,
          {"company_id": id}
        ],
        'kwargs': {},
      });
      result = 1;

      /// catch
    } catch (error) {
      result = 0;
      log("${error.runtimeType}: $error", name: "CHANGE COMPANY");
    }

    return result;
  }
}