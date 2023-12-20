import 'dart:convert';

import 'package:crypto/crypto.dart';

class Config {
  Config._();

  // static String odooServerURL = 'http://10.0.54.30:8069/';
  static String odooServerURL = 'http://192.168.43.209:8069/';
  static String odooDbName = 'odoo16_1508';
  static String storageUser = 'user';

  static String hiveBoxName = sha1
      .convert(utf8.encode('odoo_repository_demo:$odooServerURL:$odooDbName'))
      .toString();
  static String cacheSessionKey = 'session';

  static double userInfoCalendarHeight = 65.0;
}
