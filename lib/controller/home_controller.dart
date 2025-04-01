import 'package:flutter/material.dart';
import 'package:pobre_simulator/dao/transaction_dao.dart';
import 'package:pobre_simulator/model/transaction.dart';

class HomeController extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  Future<void> init() async {
    await loadTransactions();
  }

  Future<void> refresh() async {
    await loadTransactions();
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _transactions = await TransactionDAO().getAllTransactions();
  }
}
