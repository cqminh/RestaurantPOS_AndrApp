// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class ProductProductRecord extends Equatable implements OdooRecord {
  @override
  int id;
  final String? name;
  final List<dynamic>? company_id;
  final List<dynamic>? product_tmpl_id;
  final bool? active;
  final List<dynamic>? uom_id;
  final String? type;
  final List<dynamic>? pos_categ_id;
  final double? lst_price;

  ProductProductRecord({
    required this.id,
    required this.name,
    this.company_id,
    this.product_tmpl_id,
    this.active,
    this.uom_id,
    this.type,
    this.pos_categ_id,
    this.lst_price,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        company_id,
        active,
        product_tmpl_id,
        uom_id,
        type,
        pos_categ_id,
        lst_price,
      ];

  static ProductProductRecord fromJson(Map<String, dynamic> json) {
    return ProductProductRecord(
      id: json['id'],
      name: json['name'] == false ? '' : json['name'],
      company_id: json['company_id'] == false ? null : json['company_id'],
      uom_id: json['uom_id'] == false ? null : json['uom_id'],
      active: json['active'],
      product_tmpl_id:
          json['product_tmpl_id'] == false ? null : json['product_tmpl_id'],
      type: json['type'] == false ? null : json['type'],
      lst_price: json['lst_price'] == false ? null : json['lst_price'],
      pos_categ_id: json['pos_categ_id'] == false ? null : json['pos_categ_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company_id': company_id,
      'product_tmpl_id': product_tmpl_id,
      'active': active,
      'uom_id': uom_id,
      'type': type,
      'pos_categ_id': pos_categ_id,
      'lst_price': lst_price,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'id': id,
      // 'name': name,
      // //nếu là many2one thì write [0] tương ứng là id
      // 'company_id': company_id?[0],
      // 'active': active,
      // 'product_tmpl_id': product_tmpl_id?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'active',
        'company_id',
        'product_tmpl_id',
        'uom_id',
        'type',
        'pos_categ_id',
        'lst_price',
      ];
}