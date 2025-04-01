import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/util.dart';

class Transaction {
  int id;
  String title;
  CategoryType type;
  DateTime date;
  double value;
  int category;

  Transaction({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.value,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['description'],
      type: getCategoryType(json['type']),
      date: DateTime.parse(json['date']),
      value: json['amount'],
      category: json['category'],
    );
  }

  factory Transaction.newTransaction(CategoryType type) {
    return Transaction(
      id: 0,
      title: '',
      type: type,
      date: DateTime.now(),
      value: 0,
      category: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'description': title,
      'type': type.db,
      'category': category,
      'amount': value,
    };
  }
}
