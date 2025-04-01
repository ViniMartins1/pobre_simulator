import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class AmountKeyboard extends StatefulWidget {
  final Function(double) onAmountConfirmed;
  final double initialAmount;
  final String currencySymbol;
  final Color primaryColor;
  final Color secondaryColor;
  const AmountKeyboard({
    super.key,
    required this.onAmountConfirmed,
    this.initialAmount = 0.00,
    this.currencySymbol = '\$',
    this.primaryColor = const Color(0xFF000000),
    this.secondaryColor = const Color(0xFF313131),
  });

  @override
  State<AmountKeyboard> createState() => _AmountKeyboardState();
}

class _AmountKeyboardState extends State<AmountKeyboard> {
  String _amountString = '0';

  void _handleKeyPress(String key) {
    setState(() {
      switch (key) {
        case 'C':
          _amountString = '0';
          break;
        case '⌫':
          if (_amountString.length > 1) {
            _amountString = _amountString.substring(0, _amountString.length - 1);
          } else {
            _amountString = '0';
          }
          _updateDecimalPlaces();
          break;
        default:
          if (!RegExp(r'^[0-9]$').hasMatch(key)) return;

          if (_amountString == '0') {
            _amountString = key;
          } else {
            _amountString += key;
          }

          _updateDecimalPlaces();
          break;
      }
    });
  }

  void _updateDecimalPlaces() {
    _amountString = _amountString.replaceAll('.', '');

    if (_amountString.length <= 2) {
      _amountString = _amountString.padLeft(3, '0');
    }

    String wholePart = _amountString.substring(0, _amountString.length - 2);
    String decimalPart = _amountString.substring(_amountString.length - 2);

    _amountString = '$wholePart.$decimalPart';
  }

  void _confirmAmount() {
    double amount = double.parse(_amountString);
    widget.onAmountConfirmed(amount);
  }

  String get _formattedAmount {
    try {
      double amount = double.parse(_amountString);

      final formatter = NumberFormat.currency(
        symbol: widget.currencySymbol,
        decimalDigits: 2,
      );

      return formatter.format(amount);
    } catch (e) {
      return '${widget.currencySymbol}0.00';
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialAmount > 0) {
      _amountString = widget.initialAmount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: StylePresets.cShadowColor,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              _formattedAmount,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: widget.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 12),
          Column(
            children: [
              _buildKeyboardRow(['1', '2', '3']),
              _buildKeyboardRow(['4', '5', '6']),
              _buildKeyboardRow(['7', '8', '9']),
              _buildKeyboardRow(['C', '0', '⌫']),
              Row(
                children: [
                  Expanded(child: _buildConfirmButton()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      children: keys.map((key) => Expanded(child: _buildKeyButton(key))).toList(),
    );
  }

  Widget _buildKeyButton(String key) {
    Color textColor = key == '⌫' ? Colors.red : Colors.black87;
    IconData? icon;

    if (key == '⌫') {
      icon = Icons.backspace_outlined;
    }

    return Container(
      height: 64,
      margin: EdgeInsets.all(4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleKeyPress(key),
          child: Center(
            child: icon != null
                ? Icon(icon, color: textColor)
                : Text(
                    key,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: key == 'C' ? StylePresets.cLightOrange : textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      height: 64,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.primaryColor,
            widget.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: StylePresets.cShadowColor,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _confirmAmount,
          child: Center(
            child: Text(
              'Confirm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
