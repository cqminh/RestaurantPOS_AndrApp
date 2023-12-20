import 'package:get/get.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/repository/branch_record.dart';

class BranchController extends GetxController {
  RxList<BranchRecord> branchs = <BranchRecord>[].obs;
  RxList<BranchRecord> branchFilters = <BranchRecord>[].obs;
  void clear() {
    branchs = <BranchRecord>[].obs;
    branchFilters = <BranchRecord>[].obs;
  }
}
