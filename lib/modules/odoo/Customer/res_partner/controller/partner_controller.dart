import 'package:get/get.dart';
import 'package:test/modules/odoo/Customer/res_partner/repository/partner_record.dart';

class ResPartnerController extends GetxController {
  RxList<ResPartnerRecord> partners = <ResPartnerRecord>[].obs;
  Rx<ResPartnerRecord> partner = ResPartnerRecord.publicPartner().obs;
  // RxList<ResPartnerRecord> partnerfilters = <ResPartnerRecord>[].obs;
  void clear() {
    partners = <ResPartnerRecord>[].obs;
  }
}