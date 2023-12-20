// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class PosRecord extends Equatable implements OdooRecord {
  @override
  int id;
  String name;
  List<dynamic>? company_id;
  List<dynamic>? branch_id;
  bool? limit_categories;
  List<dynamic>? available_cat_ids;
  List<dynamic>? customer_default_id;
  List<dynamic>? available_pricelist_ids;
  List<dynamic>? available_pricelist_id;
  List<dynamic>? user_ids;
  List<dynamic>? payment_journal_ids;

  PosRecord({
    required this.id,
    required this.name,
    this.company_id,
    this.branch_id,
    this.limit_categories,
    this.available_cat_ids,
    this.customer_default_id,
    this.available_pricelist_id,
    this.available_pricelist_ids,
    this.user_ids,
    this.payment_journal_ids,
  });

  factory PosRecord.publicPos() => PosRecord(
        id: 0,
        name: '',
        company_id: null,
        branch_id: null,
        limit_categories: false,
        available_cat_ids: null,
        customer_default_id: null,
        available_pricelist_id: null,
        available_pricelist_ids: null,
        user_ids: null,
        payment_journal_ids: null,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        company_id,
        branch_id,
        limit_categories,
        available_cat_ids,
        customer_default_id,
        available_pricelist_id,
        available_pricelist_ids,
        user_ids,
        payment_journal_ids,
      ];

  static PosRecord fromJson(Map<String, dynamic> json) {
    return PosRecord(
      id: json['id'],
      name: json['name'],
      company_id: json['company_id'] == false ? null : json['company_id'],
      branch_id: json['branch_id'] == false ? null : json['branch_id'],
      limit_categories: json['limit_categories'],
      available_cat_ids: json['available_cat_ids'],
      customer_default_id: json['customer_default_id'] == false
          ? null
          : json['customer_default_id'],
      available_pricelist_id: json['available_pricelist_id'] == false
          ? null
          : json['available_pricelist_id'],
      available_pricelist_ids: json['available_pricelist_ids'] == false
          ? null
          : json['available_pricelist_ids'],
      user_ids: json['user_ids'] == false ? null : json['user_ids'],
      payment_journal_ids: json['payment_journal_ids'] == false
          ? null
          : json['payment_journal_ids'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch_id': branch_id,
      'company_id': company_id,
      'limit_categories': limit_categories,
      'available_cat_ids': available_cat_ids,
      'customer_default_id': customer_default_id,
      'available_pricelist_id': available_pricelist_id,
      'available_pricelist_ids': available_pricelist_ids,
      'user_ids': user_ids,
      'payment_journal_ids': payment_journal_ids,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'id': id,
      // 'name': name,
      // 'pos_type': pos_type,
      // //nếu là many2one thì write [0] tương ứng là id
      // 'hotel_restaurant_branch_id': hotel_restaurant_branch_id?[0],
      // 'company_id': company_id?[0],
      // 'limit_categories': limit_categories,
      // 'iface_available_cat_ids': iface_available_cat_ids?[0],
      // 'customer_default_id': customer_default_id?[0],
      // 'available_pricelist_id': available_pricelist_id?[0],
      // 'available_pricelist_ids': available_pricelist_ids?[0],
      // 'user_ids': user_ids?[0],
      // 'payment_journal_ids': payment_journal_ids?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'company_id',
        'branch_id',
        'limit_categories',
        'available_cat_ids',
        'customer_default_id',
        'available_pricelist_id',
        'available_pricelist_ids',
        'user_ids',
        'payment_journal_ids',
      ];
}
