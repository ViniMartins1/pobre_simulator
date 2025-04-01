import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pobre_simulator/model/category.dart';

String valueToString(double value, {bool dollarSign = false}) {
  String result = '';

  result = value.toStringAsFixed(2).replaceAll('.', ',');

  if (dollarSign) {
    result = 'R\$ $result';
  }

  return result;
}

int stringToInt(String value) {
  return int.tryParse(value) ?? 0;
}

CategoryType getCategoryType(String typeDb) {
  switch (typeDb) {
    case 'RECEIPT':
      return CategoryType.receipt;
    case 'EXPENSE':
      return CategoryType.expense;
    default:
      return CategoryType.expense;
  }
}

/// Formato -> dd/MM/yyyy
String dateTimeToString(DateTime dateTime) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(dateTime);
}

DateTime stringToDateTime(String formattedDate) {
  final formatter = DateFormat('dd/MM/yyyy');
  try {
    return formatter.parse(formattedDate);
  } catch (e) {
    return DateTime.now();
  }
}

String formatNumber(String s) {
  double value = double.tryParse(s) ?? 0.00;

  final numberFormat = NumberFormat.currency(decimalDigits: 2, locale: 'en_US', symbol: '');

  String formattedString = numberFormat.format(value);

  if (formattedString.isEmpty) {
    return "0.00";
  }
  return formattedString;
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  final int? maxDigits;
  CurrencyPtBrInputFormatter({this.maxDigits});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits != null && newValue.selection.baseOffset > maxDigits!) {
      return oldValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat.currency(decimalDigits: 2, locale: 'en_US', symbol: '');
    String newText = formatter.format(value / 100);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
