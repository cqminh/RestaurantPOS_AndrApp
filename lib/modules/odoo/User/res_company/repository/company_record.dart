import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

// ignore: must_be_immutable
class Company extends Equatable implements OdooRecord {
  @override
  int id;
  final String name;
  // final String shortName;
  Company({
    required this.id,
    required this.name,
    // required this.shortName,
  });

  factory Company.initCompany() {
    return Company(id: 0, name: "");
  }

  static Company fromJson(Map<String, dynamic> json) {
    var userId = json['id'] as int? ?? 0;
    if (userId == 0) {
      return Company.initCompany();
    }
    return Company(
      id: json["id"],
      name: json["name"],
      // shortName: json["short_name"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "short_name": shortName,
      };

  @override
  List<Object?> get props => [id, name];

  static List<String> get oFields => [
        'id',
        'name',
        // 'short_name',
      ];

  @override
  Map<String, dynamic> toVals() {
    return {
      "id": id,
      "name": name,
      // "short_name": shortName,
    };
  }
}