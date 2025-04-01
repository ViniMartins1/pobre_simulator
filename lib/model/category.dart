import 'package:flutter/material.dart';
import 'package:pobre_simulator/utils/color_utils.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:pobre_simulator/utils/util.dart';

enum CategoryType {
  receipt('RECEIPT', 'Receita', StylePresets.cGreen),
  expense('EXPENSE', 'Despesa', StylePresets.cRed);

  final String db;
  final String label;
  final Color color;
  const CategoryType(this.db, this.label, this.color);
}

class Category {
  final int id;
  final String name;
  final CategoryType type;
  final Color color;
  final int icon;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: getCategoryType(json['type']),
      color: Color(json['color']),
      icon: json['icon'],
    );
  }

  factory Category.newCategory(CategoryType type) {
    return Category(
      id: 0,
      name: '',
      type: type,
      color: type.color,
      icon: Icons.category_rounded.codePoint,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.db,
      'color': color.toInt(),
      'icon': icon,
    };
  }
}
