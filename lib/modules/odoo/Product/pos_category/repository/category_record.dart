// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class PosCategoryRecord extends Equatable implements OdooRecord {
  @override
  int id;
  final String name;
  final List<dynamic>? parent_id;

  PosCategoryRecord({
    required this.id,
    required this.name,
    this.parent_id,
  });

  factory PosCategoryRecord.publicCate() {
    return PosCategoryRecord(
      id: 0,
      name: 'Tất cả',
      parent_id: null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        parent_id,
      ];

  static PosCategoryRecord fromJson(Map<String, dynamic> json) {
    return PosCategoryRecord(
      id: json['id'],
      name: json['name'],
      parent_id: json['parent_id'] == false ? null : json['parent_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parent_id,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'id': id,
      // 'name': name,
      // //nếu là many2one thì write [0] tương ứng là id
      // 'parent_id': parent_id?[0],
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'parent_id',
      ];
}
