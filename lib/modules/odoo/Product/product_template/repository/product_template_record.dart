// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class ProductTemplateRecord extends Equatable implements OdooRecord {
  @override
  int id;
  String name;
  String? image_1920;
  bool? available_in_pos;
  List<dynamic>? pos_categ_id;
  bool? active;
  bool? sale_ok;
  double? list_price;
  // double? lst_price;
  List<dynamic>? uom_id;
  String? default_code;
  List<dynamic>? taxes_id;
  List<dynamic>? product_variant_id;
  List<dynamic>? product_variant_ids;
  // double? turnover;
  // double? qty_discount;
  // double? discount;
  // double? qty;
  String? type;

  ProductTemplateRecord({
    required this.id,
    required this.name,
    this.image_1920,
    this.available_in_pos,
    this.pos_categ_id,
    this.active,
    this.default_code,
    this.list_price,
    // this.lst_price,
    this.sale_ok,
    this.uom_id,
    this.taxes_id,
    this.product_variant_id,
    this.product_variant_ids,
    // this.turnover,
    // this.discount,
    // this.qty_discount,
    // this.qty,
    this.type,
  });

  factory ProductTemplateRecord.publicProductTemplate() {
    return ProductTemplateRecord(
      id: -1,
      name: '',
      image_1920: '',
      available_in_pos: true,
      pos_categ_id: null,
      active: true,
      default_code: '',
      list_price: 0.0,
      // lst_price: 0.0,
      sale_ok: true,
      uom_id: null,
      taxes_id: null,
      product_variant_id: null,
      product_variant_ids: null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image_1920,
        available_in_pos,
        pos_categ_id,
        active,
        default_code,
        list_price,
        // lst_price,
        sale_ok,
        uom_id,
        taxes_id,
        product_variant_id,
        product_variant_ids,
        // turnover,
        // qty,
        // qty_discount,
        // discount,
        type,
      ];

  static ProductTemplateRecord fromJson(Map<String, dynamic> json) {
    return ProductTemplateRecord(
      id: json['id'],
      name: json['name'],
      image_1920: json['image_1920'].toString(),
      available_in_pos: json['available_in_pos'],
      pos_categ_id: json['pos_categ_id'] == false ? null : json['pos_categ_id'],
      active: json['active'],
      default_code: json['default_code'].toString(),
      list_price: json['list_price'],
      // // lst_price: json['lst_price'],
      sale_ok: json['sale_ok'],
      uom_id: json['uom_id'] == false ? null : json['uom_id'],
      taxes_id: json['taxes_id'] == false ? null : json['taxes_id'],
      product_variant_id: json['product_variant_id'] == false
          ? null
          : json['product_variant_id'],
      product_variant_ids: json['product_variant_ids'] == false
          ? null
          : json['product_variant_ids'],
      // // // qty: json['qty'] == false ? null : json['qty'],
      // // // turnover: json['turnover'] == false ? null : json['turnover'],
      // // // qty_discount: json['qty_discount'] == false ? null : json['qty_discount'],
      // // // discount: json['discount'] == false ? null : json['discount'],
      type: json['type'] == false ? null : json['type'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_1920': image_1920,
      'available_in_pos': available_in_pos,
      'pos_categ_id': pos_categ_id,
      'active': active,
      'default_code': default_code,
      'list_price': list_price,
      // // 'lst_price': lst_price,
      'sale_ok': sale_ok,
      'uom_id': uom_id,
      'taxes_id': taxes_id,
      'product_variant_id': product_variant_id,
      'product_variant_ids': product_variant_ids,
      // // 'turnover': turnover,
      // // 'qty': qty,
      // // 'qty_discount': qty_discount,
      // // 'discount': discount,
      'type': type,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'id': id,
      // 'name': name,
      // //nếu là many2one thì write [0] tương ứng là id
      // 'image_1920': image_1920,
      // 'available_in_pos': available_in_pos,
      // 'pos_categ_id': pos_categ_id?[0],
      // 'active': active,
      // 'default_code': default_code,
      // 'list_price': list_price,
      // 'lst_price': lst_price,
      // 'sale_ok': sale_ok,
      // 'uom_id': uom_id?[0],
      // 'taxes_id': taxes_id?[0],
      // 'product_variant_id': product_variant_id?[0],
      // 'product_variant_ids': product_variant_ids?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'image_1920',
        'available_in_pos',
        'pos_categ_id',
        'active',
        'default_code',
        'list_price',
        // 'lst_price',
        'sale_ok',
        'uom_id',
        'taxes_id',
        'product_variant_id',
        'product_variant_ids',
        // 'turnover',
        // 'qty',
        // 'qty_discount',
        // 'discount',
        'type',
      ];
}