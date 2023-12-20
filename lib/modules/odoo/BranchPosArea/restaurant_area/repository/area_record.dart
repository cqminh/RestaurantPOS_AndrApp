// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class AreaRecord extends Equatable implements OdooRecord {
  @override
  int id;
  final String name;
  final List<dynamic>? company_id;
  final List<dynamic>? table_ids;
  final List<dynamic>? pos_ids;

  AreaRecord({
    required this.id,
    required this.name,
    this.company_id,
    this.table_ids,
    this.pos_ids,
  });

  factory AreaRecord.publicArea() => AreaRecord(
        id: 0,
        name: 'Tất cả',
        company_id: null,
        table_ids: null,
        pos_ids: null,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        company_id,
        table_ids,
        pos_ids,
      ];

  static AreaRecord fromJson(Map<String, dynamic> json) {
    return AreaRecord(
      id: json['id'],
      name: json['name'],
      company_id: json['company_id'] == false ? null : json['company_id'],
      table_ids: json['table_ids'] == false ? null : json['table_ids'],
      pos_ids: json['pos_ids'] == false
          ? null
          : json['pos_ids'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company_id': company_id,
      'table_ids': table_ids,
      'pos_ids': pos_ids,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'id': id,
      // 'name': name,
      // //nếu là many2one = many2many = one2many thì write [0] tương ứng là id
      // 'table_ids': table_ids?[0],
      // 'company_id': company_id?[0],
      // 'pos_ids': pos_ids?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'company_id',
        'table_ids',
        'pos_ids',
      ];
}