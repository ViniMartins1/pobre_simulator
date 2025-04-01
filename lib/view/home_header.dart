import 'package:flutter/material.dart';
import 'package:pobre_simulator/utils/routes.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:pobre_simulator/widgets/buttons.dart';

class HomeHeader extends StatelessWidget {
  final double balance;
  final double monthlyIncome;
  final double monthlyExpenses;

  const HomeHeader({
    super.key,
    this.balance = 4923.82,
    this.monthlyIncome = 3250.00,
    this.monthlyExpenses = 1842.37,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            StylePresets.cPrimaryColor,
            StylePresets.cSecondaryColor,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: StylePresets.cShadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: StylePresets.cBlueLight,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: StylePresets.cWhite,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryItem(
                icon: Icons.arrow_upward_rounded,
                iconColor: StylePresets.cGreen,
                iconBgColor: StylePresets.cGreenAccent,
                label: 'Entradas',
                amount: monthlyIncome,
              ),
              SizedBox(width: 16),
              _buildSummaryItem(
                icon: Icons.arrow_downward_rounded,
                iconColor: StylePresets.cRed,
                iconBgColor: StylePresets.cRedAccent,
                label: 'Saídas',
                amount: monthlyExpenses,
              ),
              SizedBox(width: 16),
              _buildSummaryItem(
                icon: Icons.bar_chart_rounded,
                iconColor: StylePresets.cBlue,
                iconBgColor: StylePresets.cBlueAccent,
                label: 'Invest',
                amount: monthlyIncome - monthlyExpenses,
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FlashButton(
                  icon: Icons.add,
                  label: 'Novo Registro',
                  onPressed: () async => await customPushNamed(context, Routes.transactionsRoute).then(
                    (value) {},
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: FlashButton(
                  icon: Icons.category_rounded,
                  label: 'Categorias',
                  onPressed: () => customPushNamed(context, Routes.categoriesRoute),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required double amount,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: StylePresets.cBlueLight,
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: StylePresets.cWhite,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
