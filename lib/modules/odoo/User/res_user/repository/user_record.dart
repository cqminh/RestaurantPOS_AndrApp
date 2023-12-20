import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

// ignore: must_be_immutable
class User extends Equatable implements OdooRecord {
  @override
  int id;
  final List<dynamic>? partnerId;
  final List<dynamic>? companyIds;
  List<dynamic>? companyId;
  final String? login;
  final String? name;
  final String? image_1920;
  final String? email;

  User({
    required this.id,
    required this.partnerId,
    required this.companyIds,
    required this.companyId,
    required this.login,
    required this.name,
    required this.image_1920,
    required this.email,
  });

  // Use for public
  factory User.publicUser() {
    return User(
        id: 0,
        partnerId: null,
        companyIds: null,
        companyId: null,
        login: null,
        name: 'Tất cả',
        image_1920: null,
        email: null);
  }

  bool get isPublic => id == 0 ? true : false;

  User copyWith({
    int? id,
    List<dynamic>? partnerId,
    List<dynamic>? companyIds,
    List<dynamic>? companyId,
    String? login,
    String? name,
    String? image_1920,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      companyIds: companyIds ?? this.companyIds,
      companyId: companyId ?? this.companyId,
      login: login ?? this.login,
      name: name ?? this.name,
      image_1920: image_1920 ?? this.image_1920,
      email: email ?? this.email,
    );
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'partner_id': partnerId,
      // 'login': login,
      // 'name': name,
      'companyId': companyId?[0],
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_id': partnerId,
      'login': login,
      'name': name,
      'image_1920': image_1920,
      'email': email,
    };
  }

  /// Creates [User] from JSON
  static User fromJson(Map<String, dynamic> json) {
    var userId = json['id'] as int? ?? 0;
    if (userId == 0) {
      return User.publicUser();
    }

    return User(
      id: userId,
      partnerId: json['partner_id'] == false ? null : json['partner_id'],
      companyIds: json['company_ids'] == false ? null : json['company_ids'],
      companyId: json['company_id'] == false ? null : json['company_id'],
      login: json['login'] == false ? null : json['login'],
      name: json['name'] == false ? null : json['name'],
      image_1920: json['image_1920'] == false ? null : json['image_1920'],
      email: json['email'] == false ? null : json['email'],
    );
  }

  // Equatable stuff to compare records
  @override
  List<Object?> get props =>
      [id, partnerId, login, name, image_1920, companyId, companyIds, email];

  // List of fields we need to fetch
  static List<String> get oFields => [
        'id',
        'partner_id',
        'company_ids',
        'company_id',
        'image_1920',
        'login',
        'name',
        'email',
      ];
}