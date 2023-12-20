import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Tools {
  Tools._();

  static String removeDiacritics(String str) {
    const vietnamese = 'aAeEoOuUiIdDyY';
    final vietnameseRegex = <RegExp>[
      RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
      RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
      RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
      RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
      RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
      RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
      RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
      RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
      RegExp(r'ì|í|ị|ỉ|ĩ'),
      RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
      RegExp(r'đ'),
      RegExp(r'Đ'),
      RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
      RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ')
    ];

    for (var i = 0; i < vietnamese.length; ++i) {
      str = str.replaceAll(vietnameseRegex[i], vietnamese[i]);
    }
    return str;
  }

  static TextInputFormatter currencyInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String value = newValue.text.replaceAll(RegExp(r'[^\d\,]'), '');
      if (value == '') {
        value = '0';
      }
      final formatter = NumberFormat('#,###.##', 'vi_VN');
      String formattedValue = formatter.format(double.parse(value));
      formattedValue = formattedValue.replaceAll('.', ',');
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      ).copyWith(
        selection: TextSelection.collapsed(
          offset: formattedValue.isNotEmpty ? formattedValue.length : 0,
        ),
      );
    });
  }

  static String doubleToVND(double? number) {
    return NumberFormat('#,###.###').format(number ?? 0);
  }

  static String dateOdooFormat(String? date) {
    return DateFormat('dd-MM-yyyy hh:mm a')
        .format(date != null ? DateTime.parse(date) : DateTime.now());
  }

  // static String? readCurrencyVND(double amount) {
  //   if (amount == 0) {
  //     return 'không';
  //   }
  //   final Map<int, String> units = {
  //     0: '',
  //     1: 'một',
  //     2: 'hai',
  //     3: 'ba',
  //     4: 'bốn',
  //     5: 'năm',
  //     6: 'sáu',
  //     7: 'bảy',
  //     8: 'tám',
  //     9: 'chín',
  //   };
  //   final Map<int, String> tens = {
  //     2: 'hai',
  //     3: 'ba',
  //     4: 'bốn',
  //     5: 'năm',
  //     6: 'sáu',
  //     7: 'bảy',
  //     8: 'tám',
  //     9: 'chín',
  //   };
  //   final Map<int, String> specialTens = {
  //     0: 'mười',
  //     1: 'mười một',
  //     5: 'mười lăm',
  //   };
  //   final List<String> groups = ['', 'nghìn', 'triệu', 'tỷ'];
  //   String result = '';
  //   int groupIndex = 0;
  //   while (amount > 0) {
  //     final int groupValue = (amount % 1000).toInt();
  //     amount = (amount / 1000).floorToDouble();
  //     if (groupValue > 0) {
  //       String groupText = '';
  //       final int hundreds = groupValue ~/ 100;
  //       final int tensAndUnits = groupValue % 100;
  //       if (hundreds > 0) {
  //         groupText += '${units[hundreds]} trăm ';
  //       }
  //       if (tensAndUnits >= 20) {
  //         final int tensDigit = tensAndUnits ~/ 10;
  //         final int unitsDigit = tensAndUnits % 10;
  //         groupText += '${tens[tensDigit]} mươi';
  //         if (unitsDigit > 0) {
  //           groupText += ' ${units[unitsDigit]}';
  //         }
  //       } else if (tensAndUnits > 0) {
  //         groupText += specialTens[tensAndUnits] ?? units[tensAndUnits];
  //       }
  //       groupText += ' ${groups[groupIndex]}';
  //       if (result.isNotEmpty) {
  //         result = '$groupText $result';
  //       } else {
  //         result = groupText;
  //       }
  //     }
  //     groupIndex++;
  //   }
  //   return result.trim();
  // }

  static String removeTagHtml(String? string) {
    string = string ?? '';
    // string dạng <tag>content</tag> thành content
    String startTag = '<';
    String endTag = '>';

    while (true) {
      int startIndex = string!.indexOf(startTag);
      if (startIndex == -1) {
        break;
      }

      int endIndex = string.indexOf(endTag, startIndex);
      if (endIndex == -1) {
        break;
      }

      string = string.substring(0, startIndex) + string.substring(endIndex + 1);
    }

    return string;
  }


}
