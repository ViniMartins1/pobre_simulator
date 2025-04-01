import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pobre_simulator/dao/category_dao.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/model/transaction.dart';
import 'package:pobre_simulator/widgets/transaction_card.dart';

class TransactionsList extends StatefulWidget {
  final List<Transaction> transactions;

  const TransactionsList({
    super.key,
    required this.transactions,
  });

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final List<Category> _cacheCategories = [];
  late Future<void> _categoriesFuture;

  Future<void> _reload() async {
    final categories = await CategoryDAO().getAll();
    _cacheCategories.clear();
    _cacheCategories.addAll(categories);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _reload().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in widget.transactions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a));

    return FutureBuilder(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading categories'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final dateKey = sortedDates[index];
              final dateTransactions = groupedTransactions[dateKey]!;
              final date = DateTime.parse(dateKey);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(date),
                  ...dateTransactions.map((transaction) {
                    final category = _cacheCategories.firstWhere((c) => c.id == transaction.category);
                    return TransactionCard(transaction: transaction, category: category);
                  }),
                  SizedBox(height: 16),
                ],
              );
            },
          );
        });
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateFormat = DateFormat('EEEE, MMMM d');

    String dateText;
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      dateText = 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      dateText = 'Yesterday';
    } else {
      dateText = dateFormat.format(date);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        dateText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
