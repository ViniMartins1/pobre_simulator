import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:pobre_simulator/dao/category_dao.dart';
import 'package:pobre_simulator/dao/transaction_dao.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/model/transaction.dart';
import 'package:pobre_simulator/utils/util.dart';

class TransactionController extends ChangeNotifier {
  int _transactionId = 0;
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime _date = DateTime.now();
  CategoryType _operation = CategoryType.expense;
  int _categoryId = 0;
  List<Category> _categories = [];

  Future<void> init({Transaction? transaction}) async {
    reset();
    _transactionId = 0;
    _categoryId = 0;
    _operation = transaction?.type ?? CategoryType.expense;
    _date = transaction?.date ?? DateTime.now();
    if (transaction != null && transaction.id > 0) {
      _transactionId = transaction.id;
      _categoryId = transaction.category;
      descController.text = transaction.title;
      amountController.text = valueToString(transaction.value);
    }
    await loadCategories();
    notifyListeners();
  }

  void reset() {
    descController.clear();
    amountController.clear();
    _date = DateTime.now();
    _operation = CategoryType.expense;
    _transactionId = 0;
    _categoryId = 0;
  }

  void setDate(DateTime date) {
    if (date == _date) {
      return;
    }

    _date = date;
    notifyListeners();
  }

  DateTime get selectedDate => _date;

  void setCategory(int id) {
    if (id == _categoryId) {
      return;
    }
    _categoryId = id;
    notifyListeners();
  }

  void setTransactionId(int id) {
    if (id == _transactionId) {
      return;
    }

    _transactionId = id;
  }

  int get id => _transactionId;

  Future<void> loadCategories() async {
    _categories = await CategoryDAO().getAll();
    notifyListeners();
  }

  void setOperation(CategoryType type) {
    if (_operation == type) {
      return;
    }

    _operation = type;
    setCategory(0);

    notifyListeners();
  }

  CategoryType get operation => _operation;

  int get categoryId => _categoryId;

  List<Category> get categories {
    return _categories.where((element) => element.type == _operation).toList();
  }

  Future<void> save() async {
    try {
      final transaction = Transaction(
        id: _transactionId,
        title: descController.text,
        value: double.tryParse(amountController.text) ?? 0,
        date: _date,
        category: _categoryId,
        type: _operation,
      );

      if (transaction.id > 0) {
        await TransactionDAO().updateTransaction(transaction);
      } else {
        await TransactionDAO().insertTransaction(transaction);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
