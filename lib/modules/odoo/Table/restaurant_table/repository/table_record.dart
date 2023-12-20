// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class TableRecord extends Equatable implements OdooRecord {
  @override
  int id;
  String? name;
  int? capacity;
  List<dynamic>? company_id;
  List<dynamic>? pos_id;
  List<dynamic>? area_id;
  String? status;

  TableRecord({
    required this.id,
    this.name,
    this.company_id,
    this.capacity,
    this.status,
    this.pos_id,
    this.area_id,
  });

  factory TableRecord.publicTable() => TableRecord(
        id: 0,
        name: 'Tất cả',
        company_id: null,
        capacity: 0,
        status: '',
        pos_id: null,
        area_id: null,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        company_id,
        pos_id,
        area_id,
        status,
        capacity,
      ];

  static TableRecord fromJson(Map<String, dynamic> json) {
    return TableRecord(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      company_id: json['company_id'] == false ? null : json['company_id'],
      area_id: json['area_id'] == false ? null : json['area_id'],
      status: json['status'],
      pos_id: json['pos_id'] == false ? null : json['pos_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'status': status,
      'company_id': company_id,
      'pos_id': pos_id,
      'area_id': area_id,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      'id': id,
      'name': name,
      //nếu là many2one thì write [0] tương ứng là id
      'status': status,
      'capacity': capacity,
      // 'pos_id': pos_id?[0],
      // 'area_id': area_id?[0],
      // 'company_id': company_id?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'company_id',
        'status',
        'capacity',
        'pos_id',
        'area_id',
      ];
}
