// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_record.dart';

class SaleOrderRecord extends Equatable implements OdooRecord {
  @override
  int id;
  String name;
  List<dynamic>? company_id;
  List<dynamic>? order_line;
  List<dynamic>? warehouse_id;
  List<dynamic>? pos_id;
  List<dynamic>? table_id;
  String? note;
  String? state;
  List<dynamic>? partner_id_hr;
  List<dynamic>? partner_id;
  List<dynamic>? pricelist_id;
  double? amount_untaxed;
  double? amount_tax;
  // double? total_discount;
  double? amount_total;
  int? message_attachment_count;
  String? date_order;
  String? check_in;
  String? check_out;
  List<dynamic>? user_id;
  String? write_date;
  List<dynamic>? payments;
  String? namePayments;
  // String? surcharge_type;
  // double? surcharge;

  SaleOrderRecord({
    required this.id,
    required this.name,
    this.order_line,
    this.pos_id,
    this.table_id,
    this.state,
    this.partner_id_hr,
    this.partner_id,
    this.amount_tax,
    this.amount_total,
    this.amount_untaxed,
    // this.total_discount,
    this.date_order,
    this.message_attachment_count,
    this.pricelist_id,
    this.warehouse_id,
    this.company_id,
    this.check_in,
    this.check_out,
    this.note,
    this.user_id,
    this.payments,
    this.namePayments,
    this.write_date,
    // this.surcharge,
    // this.surcharge_type,
  });

  factory SaleOrderRecord.publicSaleOrder() {
    return SaleOrderRecord(
      id: -1,
      name: 'New',
      pos_id: null,
      table_id: null,
      state: 'draft',
      partner_id_hr: null,
      partner_id: null,
      company_id: null,
      note: null,
      message_attachment_count: 0,
      warehouse_id: null,
    );
  }
  // factory SaleOrderRecord.publicSaleOrderHotel() {
  //   return SaleOrderRecord(
  //     id: -1,
  //     name: 'New',
  //     date_order: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
  //     pos_id: null,
  //     company_id: null,
  //     state: 'draft',
  //     pricelist_id: null,
  //     partner_id_hr: null,
  //     partner_id: null,
  //     message_attachment_count: 0,
  //     warehouse_id: null,
  //     note: null,
  //   );
  // }
  factory SaleOrderRecord.publicSaleOrderRestaurant() {
    return SaleOrderRecord(
      id: -1,
      name: 'New',
      date_order: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      pos_id: null,
      table_id: null,
      company_id: null,
      state: 'draft',
      pricelist_id: null,
      partner_id_hr: null,
      partner_id: null,
      message_attachment_count: 0,
      warehouse_id: null,
      note: null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        order_line,
        table_id,
        pos_id,
        state,
        partner_id_hr,
        partner_id,
        amount_tax,
        amount_total,
        amount_untaxed,
        // total_discount,
        date_order,
        warehouse_id,
        pricelist_id,
        message_attachment_count,
        company_id,
        check_in,
        check_out,
        note,
        user_id,
        payments,
        namePayments,
        write_date,
        // surcharge_type,
        // surcharge,
      ];

  static SaleOrderRecord fromJson(Map<String, dynamic> json) {
    return SaleOrderRecord(
      id: json['id'],
      name: json['name'],
      state: json['state'] == false ? "" : json['state'],
      order_line: json['order_line'] == false ? null : json['order_line'],
      pos_id: json['pos_id'] == false
          ? null
          : json['pos_id'],
      // total_discount:
          // // json['total_discount'] == false ? 0.0 : json['total_discount'],
      amount_untaxed:
          json['amount_untaxed'] == false ? 0.0 : json['amount_untaxed'],
      amount_total: json['amount_total'] == false ? 0.0 : json['amount_total'],
      amount_tax: json['amount_tax'] == false ? 0.0 : json['amount_tax'],
      date_order: [false, null].contains(json['date_order'])
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
          : json['date_order'],
      warehouse_id: json['warehouse_id'] == false ? null : json['warehouse_id'],
      pricelist_id: json['pricelist_id'] == false ? null : json['pricelist_id'],
      message_attachment_count: json['message_attachment_count'] == false
          ? 0
          : json['message_attachment_count'],
      company_id: json['company_id'] == false ? 0 : json['company_id'],
      check_in: [false, null].contains(json['check_in'])
          ? null
          : DateTime.parse(json['check_in']).toString(),
      check_out: [false, null].contains(json['check_out'])
          ? null
          : DateTime.parse(json['check_out']).toString(),

      // chỉ khi là NULL thì mới write & create được nếu để [] thì khi write sẽ lỗi
      table_id: json['table_id'] == false ? null : json['table_id'],
      partner_id_hr:
          json['partner_id_hr'] == false ? null : json['partner_id_hr'],
      partner_id: json['partner_id_hr'] == false ? null : json['partner_id_hr'],
      note: json['note'] == false ? null : json['note'],
      write_date: [false, null].contains(json['write_date'])
          ? null
          : DateTime.parse(json['write_date'])
              .add(const Duration(hours: 7))
              .toString(),
      user_id: json['user_id'] == false ? null : json['user_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order_line': order_line,
      'table_id': table_id,
      'pos_id': pos_id,
      'state': state,
      'partner_id_hr': partner_id_hr,
      'partner_id': partner_id_hr,
      'amount_tax': amount_tax,
      'amount_total': amount_total,
      'amount_untaxed': amount_untaxed,
      // // 'total_discount': total_discount,
      'date_order': date_order,
      'warehouse_id': warehouse_id,
      'pricelist_id': pricelist_id,
      'message_attachment_count': message_attachment_count,
      'company_id': company_id,
      'check_in': check_in,
      'check_out': check_out,
      'note': note,
      'write_date': write_date,
    };
  }

  @override
  Map<String, dynamic> toVals() {
    // khi create chỉ nhận value = [] | null còn khi write thì chỉ nhận value = null
    return {
      // có thể write
      'id': id,
      'name': name,
      'state': state,
      'table_id': table_id?[0],
      'partner_id_hr': partner_id_hr?[0],
      'partner_id': partner_id_hr?[0],
      'note': note,

      'date_order': date_order,
      'pricelist_id': pricelist_id?[0],
      'check_in': check_in,
      'check_out': check_out,
      'pos_id': pos_id?[0],
      'warehouse_id': warehouse_id?[0],
      'company_id': company_id?[0],
      'message_attachment_count': message_attachment_count,

      //nếu là many2one thì write [0] tương ứng là id
      // 'order_line': order_line?[0],
      // 'amount_tax': amount_tax,
      // 'amount_total': amount_total,
      // 'amount_untaxed': amount_untaxed,
      // 'total_discount': total_discount,
    };
  }

  static List<String> get oFields => [
        'id',
        'name',
        'order_line',
        'table_id',
        'pos_id',
        'state',
        'partner_id_hr',
        'partner_id',
        'amount_tax',
        'amount_total',
        'amount_untaxed',
        // 'total_discount',
        'date_order',
        'warehouse_id',
        'pricelist_id',
        'message_attachment_count',
        'company_id',
        'check_in',
        'check_out',
        'note',
        'user_id',
        // 'payments',
        // 'namePayments',
        'write_date',
        // 'surcharge_type',
        // 'surcharge',
      ];
}