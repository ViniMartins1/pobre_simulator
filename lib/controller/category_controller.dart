import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:pobre_simulator/config/appdata.dart';
import 'package:pobre_simulator/dao/category_dao.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/util.dart';

class CategoryController extends ChangeNotifier {
  int _id = 0;
  TextEditingController nameController = TextEditingController();
  CategoryType _type = CategoryType.expense;
  Color _color = AppData.colorPickerInitialColor;
  TextEditingController iconController = TextEditingController(text: AppData.iconPickerInitialIcon.codePoint.toString());

  void init({Category? category, required CategoryType type}) {
    reset();
    _type = type;
    if (category != null) {
      _id = category.id;
      _type = category.type;
      nameController.text = category.name;
      _color = category.color;
      iconController.text = '${category.icon}';
    }
  }

  void reset() {
    _id = 0;
    nameController.clear();
    iconController.clear();
    _type = CategoryType.expense;
    _color = AppData.colorPickerInitialColor;
    iconController.text = AppData.iconPickerInitialIcon.codePoint.toString();
  }

  set type(CategoryType value) {
    if (value != _type) {
      _type = value;
    }
  }

  Color get color => _color;

  IconData get icon => IconData(stringToInt(iconController.text), fontFamily: 'MaterialIcons');

  CategoryType get type => _type;

  void changeType() {
    _type = type == CategoryType.expense ? CategoryType.receipt : CategoryType.expense;
    notifyListeners();
  }

  void changeColor(int color) {
    _color = Color(color);
    notifyListeners();
    if (kDebugMode) print("Color changed to: $_color");
  }

  void changeIcon(int icon) {
    iconController.text = '$icon';
    notifyListeners();
  }

  Future<void> save() async {
    try {
      Category category = Category(
        id: _id,
        name: nameController.text,
        type: _type,
        color: _color,
        icon: stringToInt(iconController.text),
      );

      if (category.id > 0) {
        await CategoryDAO().updateCategory(category);
      } else {
        await CategoryDAO().insertCategory(category);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
