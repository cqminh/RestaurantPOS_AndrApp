// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class SaleOrderLineRecord extends Equatable implements OdooRecord {
  @override
  int id;
  String? name;
  double? product_uom_qty;
  double? qty_reserved;
  double? price_unit;
  double? price_total;
  String? remarks;
  // final String? state;
  List<dynamic>? order_id;
  List<dynamic>? product_id;
  List<dynamic>? product_uom;
  List<dynamic>? route_id;
  // String? write_date;

  factory SaleOrderLineRecord.publicSaleOrderLine() {
    return SaleOrderLineRecord(
      id: 0,
      name: '',
      price_unit: 0.0,
      order_id: null,
      product_uom: null,
      qty_reserved: 0.0,
      product_uom_qty: 1.0,
      product_id: null,
      remarks: null,
      route_id: null,
    );
  }

  SaleOrderLineRecord({
    required this.id,
    this.name,
    this.order_id,
    this.price_total,
    this.price_unit,
    this.route_id,
    this.qty_reserved,
    this.product_uom_qty,
    this.remarks,
    this.product_id,
    this.product_uom,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        order_id,
        price_total,
        price_unit,
        route_id,
        qty_reserved,
        product_uom_qty,
        remarks,
        product_id,
        product_uom,
      ];

  static SaleOrderLineRecord fromJson(Map<String, dynamic> json) {
    return SaleOrderLineRecord(
      id: json['id'],
      name: json['name'],
      price_total: json['price_total'] == false ? 0.0 : json['price_total'],
      product_uom_qty:
          json['product_uom_qty'] == false ? 0.0 : json['product_uom_qty'],
      qty_reserved: json['qty_reserved'] == false ? 0.0 : json['qty_reserved'],
      price_unit: json['price_unit'] == false ? 0.0 : json['price_unit'],
      remarks: json['remarks'] == false ? null : json['remarks'],
      order_id: json['order_id'] == false ? null : json['order_id'],
      product_id: json['product_id'] == false ? null : json['product_id'],
      product_uom: json['product_uom'] == false ? null : json['product_uom'],
      route_id: json['route_id'] == false ? null : json['route_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order_id': order_id,
      'price_total': price_total,
      'price_unit': price_unit,
      'qty_reserved': qty_reserved,
      'product_uom_qty': product_uom_qty,
      'remarks': remarks,
      'product_id': product_id,
      'product_uom': product_uom,
      'route_id': route_id,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    log('ffff $name');
    return {
      'id': id,
      'name': name,
      'price_unit': price_unit,
      'qty_reserved': qty_reserved,
      'product_uom_qty': product_uom_qty,
      'remarks': remarks,
      'order_id': order_id?[0],
      'product_id': product_id?[0],
      'product_uom': product_uom?[0],
      // nếu là many2one thì write [0] tương ứng là id
      // 'price_total': price_total,
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'order_id',
        'price_total',
        'price_unit',
        'route_id',
        'qty_reserved',
        'product_uom_qty',
        'remarks',
        'product_id',
        'product_uom',
      ];
}