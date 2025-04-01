import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/model/transaction.dart';
import 'package:pobre_simulator/utils/color_utils.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final Category category;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: StylePresets.cShadowColor,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: category.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            IconData(category.icon, fontFamily: 'MaterialIcons'),
            color: ColorUtils.getIconColor(category.color),
            size: 24,
          ),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          category.name,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.type == CategoryType.expense ? "-" : "+"}\$${transaction.value.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: transaction.type == CategoryType.expense ? StylePresets.cRed : StylePresets.cGreen,
              ),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('h:mm a').format(transaction.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigate to transaction details or edit screen
        },
      ),
    );
  }
}
