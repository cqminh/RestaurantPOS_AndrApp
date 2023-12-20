// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class StockPickingRecord extends Equatable implements OdooRecord {
  @override
  int id;
  final String name;
  final String? origin;
  final String? note;
  final List<dynamic>? backorder_id;
  final List<dynamic>? move_ids_without_package;
  final List<dynamic>? company_id;
  final List<dynamic>? sale_id;
  final List<dynamic>? pos_order_id;
  final String? state;

  StockPickingRecord({
    required this.id,
    required this.name,
    this.origin,
    this.backorder_id,
    this.company_id,
    this.note,
    this.pos_order_id,
    this.move_ids_without_package,
    this.sale_id,
    this.state,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        origin,
        backorder_id,
        company_id,
        note,
        pos_order_id,
        sale_id,
        state,
        move_ids_without_package,
      ];

  static StockPickingRecord fromJson(Map<String, dynamic> json) {
    return StockPickingRecord(
      id: json['id'],
      name: json['name'],
      state: json['state'] == false ? '' : json['state'],
      origin: json['origin'] == false ? '' : json['origin'],
      note: json['note'] == false ? '' : json['note'],
      backorder_id: json['backorder_id'] == false ? null : json['backorder_id'],
      company_id: json['company_id'] == false ? null : json['company_id'],
      pos_order_id: json['pos_order_id'] == false ? null : json['pos_order_id'],
      move_ids_without_package: json['move_ids_without_package'] == false
          ? null
          : json['move_ids_without_package'],
      sale_id: json['sale_id'] == false ? null : json['sale_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'backorder_id': backorder_id,
      'company_id': company_id,
      'note': note,
      'pos_order_id': pos_order_id,
      'sale_id': sale_id,
      'state': state,
      'move_ids_without_package': move_ids_without_package,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'id': id,
      // 'name': name,
      // 'state': state,
      // 'origin': origin,
      // 'note': note,
      // //nếu là many2one thì write [0] tương ứng là id
      // 'backorder_id': backorder_id?[0],
      // 'company_id': company_id?[0],
      // 'pos_order_id': pos_order_id?[0],
      // 'move_ids_without_package': move_ids_without_package?[0],
      // 'sale_id': sale_id?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'origin',
        'backorder_id',
        'company_id',
        'note',
        'pos_order_id',
        'sale_id',
        'state',
        'move_ids_without_package',
      ];
}