// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class ResPartnerRecord extends Equatable implements OdooRecord {
  @override
  int id;
  String? name;
  List<dynamic>? company_id;
  // List<dynamic>? company_ids;
  List<dynamic>? property_product_pricelist;
  List<dynamic>? parent_id;
  // String? gender;
  String? mobile;
  String? phone;
  List<dynamic>? country_id;
  List<dynamic>? state_id;
  String? street;
  String? street2;
  String? vat;
  String? email;
  String? company_type;
  bool? is_company;

  factory ResPartnerRecord.publicPartner() => ResPartnerRecord(
        id: -1,
        name: null,
        company_id: null,
        // company_ids: null,
        property_product_pricelist: null,
        company_type: 'person',
        parent_id: null,
        // gender: null,
        mobile: null,
        phone: null,
        country_id: null,
        state_id: null,
        street: null,
        street2: null,
        vat: null,
        email: null,
        is_company: null,
      );

  ResPartnerRecord({
    required this.id,
    this.name,
    this.company_id,
    // this.company_ids,
    this.property_product_pricelist,
    this.country_id,
    this.state_id,
    // this.gender,
    this.email,
    this.mobile,
    this.parent_id,
    this.phone,
    this.street,
    this.street2,
    this.vat,
    this.company_type,
    this.is_company,
  });

  @override
  List<Object?> get props =>
      [id, name, property_product_pricelist, company_id, is_company];

  static ResPartnerRecord fromJson(Map<String, dynamic> json) {
    return ResPartnerRecord(
      id: json['id'],
      name: json['name'] == false ? null : json['name'],
      property_product_pricelist: json['property_product_pricelist'] == false
          ? null
          : json['property_product_pricelist'],
      company_id: json['company_id'] == false ? null : json['company_id'],
      // company_ids: json['company_ids'] == false ? null : json['company_ids'],
      parent_id: json['parent_id'] == false ? null : json['parent_id'],
      // // // gender: json['gender'] == false ? null : json['gender'],
      mobile: json['mobile'] == false ? null : json['mobile'],
      phone: json['phone'] == false ? null : json['phone'],
      street: json['street'] == false ? null : json['street'],
      street2: json['street2'] == false ? null : json['street2'],
      vat: json['vat'] == false ? null : json['vat'],
      company_type: json['company_type'] == false ? null : json['company_type'],
      email: json['email'] == false ? null : json['email'],
      is_company: json['is_company'],
      country_id: json['country_id'] == false ? null : json['country_id'],
      state_id: json['state_id'] == false ? null : json['state_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'property_product_pricelist': property_product_pricelist,
      'company_id': company_id,
      // 'company_ids': company_ids,
      'parent_id': parent_id,
      // // 'gender': gender,
      'mobile': mobile,
      'phone': phone,
      'country_id': country_id,
      'state_id': state_id,
      'street': street,
      'street2': street2,
      'vat': vat,
      'email': email,
      'company_type': company_type,
      'is_company': is_company,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      'id': id,
      'name': name,
      //nếu là many2one thì write [0] tương ứng là id
      'property_product_pricelist': property_product_pricelist?[0],
      'company_id': company_id?[0],
      // 'company_ids': company_ids != null ? [[6, false, company_ids]] : company_ids,
      'parent_id': parent_id?[0],
      // // 'gender': gender,
      'mobile': mobile,
      'phone': phone,
      'country_id': country_id?[0],
      'state_id': state_id?[0],
      'street': street,
      'street2': street2,
      'vat': vat,
      'email': email,
      'company_type': company_type,
      'is_company': is_company,
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'property_product_pricelist',
        'company_id',
        // 'company_ids',
        'parent_id',
        // 'gender',
        'mobile',
        'phone',
        'country_id',
        'state_id',
        'street',
        'street2',
        'vat',
        'email',
        'company_type',
        'is_company',
      ];
}