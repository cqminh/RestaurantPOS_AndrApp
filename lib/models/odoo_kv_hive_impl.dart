import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/common/config/config.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_session.dart';
import 'package:test/common/third_party/OdooRepository/src/kv_store.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_id.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_rpc_call.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/repository/area_record.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/repository/branch_record.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/repository/pos_record.dart';
import 'package:test/modules/odoo/Customer/res_partner/repository/partner_record.dart';
import 'package:test/modules/odoo/Inventory/stock_move/repository/stock_move_record.dart';
import 'package:test/modules/odoo/Inventory/stock_picking/repository/stock_picking_record.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_record.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';
import 'package:test/modules/odoo/Product/pos_category/repository/category_record.dart';
import 'package:test/modules/odoo/Product/product_product/repository/product_product_record.dart';
import 'package:test/modules/odoo/Product/product_template/repository/product_template_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';
import 'package:test/modules/odoo/User/res_company/repository/company_record.dart';
import 'package:test/modules/odoo/User/res_user/repository/user_record.dart';

typedef SessionChangedCallback = void Function(OdooSession sessionId);

class OdooKvHive implements OdooKv {
  late Box box;

  OdooKvHive();

  @override
  Future<void> init() async {
    Hive.registerAdapter(OdooSessionAdapter());
    Hive.registerAdapter(OdooRpcCallAdapter());
    Hive.registerAdapter(OdooIdAdapter());
    // Odoo's module Adapter
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CompanyAdapter());
    Hive.registerAdapter(AreaAdapter());
    Hive.registerAdapter(BranchAdapter());
    Hive.registerAdapter(PosAdapter());
    Hive.registerAdapter(TableAdapter());
    Hive.registerAdapter(ResPartnerAdapter());
    Hive.registerAdapter(ProductTemplateAdapter());
    Hive.registerAdapter(SaleOrderAdapter());
    Hive.registerAdapter(ProductProductAdapter());
    Hive.registerAdapter(PosCategoryAdapter());
    Hive.registerAdapter(SaleOrderLineAdapter());
    Hive.registerAdapter(StockMoveAdapter());
    Hive.registerAdapter(StockPickingAdapter());

    Directory? directory = await getTemporaryDirectory();
    Hive.init("${directory.path}/odooHive");
    box = await Hive.openBox(Config.hiveBoxName);
  }

  @override
  Future<void> close() {
    return box.close();
  }

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> put(dynamic key, dynamic value) {
    return box.put(key, value);
  }

  @override
  Future<void> delete(dynamic key) {
    return box.delete(key);
  }

  @override
  Iterable<dynamic> get keys => box.keys;
}

/// Callback for session changed events
SessionChangedCallback storeSesion(OdooKv cache) {
  void sessionChanged(OdooSession sessionId) {
    if (sessionId.id == '') {
      cache.delete(Config.cacheSessionKey);
    } else {
      cache.put(Config.cacheSessionKey, sessionId);
    }
  }

  return sessionChanged;
}

/// Adapter to store and read OdooSession from persistent storage
class OdooSessionAdapter extends TypeAdapter<OdooSession> {
  @override
  final typeId = 0;

  @override
  OdooSession read(BinaryReader reader) {
    return OdooSession.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, OdooSession obj) {
    writer.write(obj.toJson());
  }
}

/// Adapter to store and read OdooRpcCall to/from Hive
class OdooRpcCallAdapter extends TypeAdapter<OdooRpcCall> {
  @override
  final typeId = 2;

  @override
  OdooRpcCall read(BinaryReader reader) {
    return OdooRpcCall.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, OdooRpcCall obj) {
    writer.write(obj.toJson());
  }
}

/// Adapter to store and read OdooId to/from Hive
class OdooIdAdapter extends TypeAdapter<OdooId> {
  @override
  final typeId = 3;

  @override
  OdooId read(BinaryReader reader) {
    return OdooId.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, OdooId obj) {
    writer.write(obj.toJson());
  }
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 4;

  @override
  User read(BinaryReader reader) {
    return User.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.toJson());
  }
}

class CompanyAdapter extends TypeAdapter<Company> {
  @override
  final typeId = 5;

  @override
  Company read(BinaryReader reader) {
    return Company.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, Company obj) {
    writer.write(obj.toJson());
  }
}

class AreaAdapter extends TypeAdapter<AreaRecord> {
  @override
  final typeId = 6;

  @override
  AreaRecord read(BinaryReader reader) {
    return AreaRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, AreaRecord obj) {
    writer.write(obj.toJson());
  }
}

class PosAdapter extends TypeAdapter<PosRecord> {
  @override
  final typeId = 7;

  @override
  PosRecord read(BinaryReader reader) {
    return PosRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, PosRecord obj) {
    writer.write(obj.toJson());
  }
}

class BranchAdapter extends TypeAdapter<BranchRecord> {
  @override
  final typeId = 8;

  @override
  BranchRecord read(BinaryReader reader) {
    return BranchRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, BranchRecord obj) {
    writer.write(obj.toJson());
  }
}

class TableAdapter extends TypeAdapter<TableRecord> {
  @override
  final typeId = 9;

  @override
  TableRecord read(BinaryReader reader) {
    return TableRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, TableRecord obj) {
    writer.write(obj.toJson());
  }
}

class ResPartnerAdapter extends TypeAdapter<ResPartnerRecord> {
  @override
  final typeId = 10;

  @override
  ResPartnerRecord read(BinaryReader reader) {
    return ResPartnerRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, ResPartnerRecord obj) {
    writer.write(obj.toJson());
  }
}

class ProductTemplateAdapter extends TypeAdapter<ProductTemplateRecord> {
  @override
  final typeId = 11;

  @override
  ProductTemplateRecord read(BinaryReader reader) {
    return ProductTemplateRecord.fromJson(
        Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, ProductTemplateRecord obj) {
    writer.write(obj.toJson());
  }
}

class SaleOrderAdapter extends TypeAdapter<SaleOrderRecord> {
  @override
  final typeId = 12;

  @override
  SaleOrderRecord read(BinaryReader reader) {
    return SaleOrderRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, SaleOrderRecord obj) {
    writer.write(obj.toJson());
  }
}

class ProductProductAdapter extends TypeAdapter<ProductProductRecord> {
  @override
  final typeId = 13;

  @override
  ProductProductRecord read(BinaryReader reader) {
    return ProductProductRecord.fromJson(
        Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, ProductProductRecord obj) {
    writer.write(obj.toJson());
  }
}

class PosCategoryAdapter extends TypeAdapter<PosCategoryRecord> {
  @override
  final typeId = 14;

  @override
  PosCategoryRecord read(BinaryReader reader) {
    return PosCategoryRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, PosCategoryRecord obj) {
    writer.write(obj.toJson());
  }
}

class SaleOrderLineAdapter extends TypeAdapter<SaleOrderLineRecord> {
  @override
  final typeId = 15;

  @override
  SaleOrderLineRecord read(BinaryReader reader) {
    return SaleOrderLineRecord.fromJson(
        Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, SaleOrderLineRecord obj) {
    writer.write(obj.toJson());
  }
}

class StockMoveAdapter extends TypeAdapter<StockMoveRecord> {
  @override
  final typeId = 16;

  @override
  StockMoveRecord read(BinaryReader reader) {
    return StockMoveRecord.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, StockMoveRecord obj) {
    writer.write(obj.toJson());
  }
}

class StockPickingAdapter extends TypeAdapter<StockPickingRecord> {
  @override
  final typeId = 17;

  @override
  StockPickingRecord read(BinaryReader reader) {
    return StockPickingRecord.fromJson(
        Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, StockPickingRecord obj) {
    writer.write(obj.toJson());
  }
}
