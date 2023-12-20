// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class StockMoveRecord extends Equatable implements OdooRecord {
  @override
  int id;
  final String name;
  final List<dynamic>? picking_id;
  final List<dynamic>? product_id;
  final String? state;
  final double? quantity_done;

  StockMoveRecord({
    required this.id,
    required this.name,
    this.picking_id,
    this.product_id,
    this.state,
    this.quantity_done,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        picking_id,
        product_id,
        state,
        quantity_done,
      ];

  static StockMoveRecord fromJson(Map<String, dynamic> json) {
    return StockMoveRecord(
      id: json['id'],
      name: json['name']== false ? '' : json['name'],
      quantity_done:
          json['quantity_done'] == false ? 0.0 : json['quantity_done'],
      state: json['state'] == false ? '' : json['state'],
      picking_id: json['picking_id'] == false ? null : json['picking_id'],
      product_id: json['product_id'] == false ? null : json['product_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'product_id': product_id,
      'picking_id': picking_id,
      'state': state,
      'quantity_done': quantity_done,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
    //   'id': id,
    //   'name': name,
    //   'state': state,
    //   'quantity_done': quantity_done,
    //   //nếu là many2one thì write [0] tương ứng là id
    //   'product_id': product_id?[0],
    //   'picking_id': picking_id?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'product_id',
        'picking_id',
        'state',
        'quantity_done',
      ];
}