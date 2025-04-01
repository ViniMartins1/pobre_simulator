import 'package:flutter/material.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class AppData {
  Category initialExpense = Category(
    id: 0,
    name: 'Saída',
    type: CategoryType.expense,
    icon: Icons.attach_money.codePoint,
    color: StylePresets.cRed,
  );

  Category initialReceipt = Category(
    id: 0,
    name: 'Entrada',
    type: CategoryType.receipt,
    icon: Icons.attach_money.codePoint,
    color: StylePresets.cGreen,
  );

  static final Color colorPickerInitialColor = StylePresets.cBlue;
  static final IconData iconPickerInitialIcon = Icons.category_rounded;
}
