// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class BranchRecord extends Equatable implements OdooRecord {
  @override
  int id;
  final String name;
  final List<dynamic>? company_id;
  final List<dynamic>? user_id;
  final List<dynamic>? user_ids;
  final List<dynamic>? pos_ids;
  final List<dynamic>? warehouse_id;
  final bool? done_invisible;
  // final bool? debit_payment;
  final List<dynamic>? payment_journal_ids;
  String? address;
  String? phone;
  double? period;
  String? datetime_now;

  BranchRecord(
      {required this.id,
      required this.name,
      this.company_id,
      this.user_id,
      this.user_ids,
      this.pos_ids,
      this.warehouse_id,
      this.done_invisible,
      // this.debit_payment,
      this.payment_journal_ids,
      this.address,
      this.period,
      this.phone,
      this.datetime_now});

  @override
  List<Object?> get props => [
        id,
        name,
        company_id,
        user_id,
        user_ids,
        pos_ids,
        warehouse_id,
        done_invisible,
        // debit_payment,
        payment_journal_ids,
        phone,
        period,
        address,
        datetime_now,
      ];

  static BranchRecord fromJson(Map<String, dynamic> json) {
    return BranchRecord(
      id: json['id'],
      name: json['name'],
      done_invisible: json['done_invisible'],
      // debit_payment: json['debit_payment'],
      warehouse_id: json['warehouse_id'] == false ? null : json['warehouse_id'],
      company_id: json['company_id'] == false ? null : json['company_id'],
      user_id: json['user_id'] == false ? null : json['user_id'],
      user_ids: json['user_ids'] == false ? null : json['user_ids'],
      pos_ids: json['pos_ids'] == false ? null : json['pos_ids'],
      payment_journal_ids: json['payment_journal_ids'] == false
          ? null
          : json['payment_journal_ids'],
      phone: json['phone'] == false ? null : json['phone'],
      address: json['address'] == false ? null : json['address'],
      period: json['period'] == false ? null : json['period'],
      datetime_now: json['datetime_now'] == false ? null : json['datetime_now'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': user_id,
      'company_id': company_id,
      'user_ids': user_ids,
      'pos_ids': pos_ids,
      'warehouse_id': warehouse_id,
      'done_invisible': done_invisible,
      // 'debit_payment': debit_payment,
      'payment_journal_ids': payment_journal_ids,
      'period': period,
      'address': address,
      'phone': phone,
      'datetime_now': datetime_now,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    return {
      // 'id': id,
      // 'name': name,
      // //nếu là many2one thì write [0] tương ứng là id
      // 'user_id': user_id?[0],
      // 'company_id': company_id?[0],
      // 'user_ids': user_ids?[0],
      // 'hotel_restaurant_pos_ids': hotel_restaurant_pos_ids?[0],
      // 'warehouse_id': warehouse_id?[0],
      // 'done_invisible': done_invisible,
      // 'payment_journal_ids': payment_journal_ids?[0],
      // 'period': period,
      // 'address': address,
      // 'phone': phone,
      // 'datetime_now': datetime_now,
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'company_id',
        'user_id',
        'user_ids',
        'pos_ids',
        'warehouse_id',
        'done_invisible',
        // 'debit_payment',
        'payment_journal_ids',
        'period',
        'address',
        'phone',
        'datetime_now',
      ];
}
