import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class OperationSelect extends StatefulWidget {
  final EdgeInsets padding;
  final Function onChanged;
  final CategoryType operation;
  const OperationSelect({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    required this.onChanged,
    this.operation = CategoryType.expense,
  });

  @override
  State<OperationSelect> createState() => _OperationSelectState();
}

class _OperationSelectState extends State<OperationSelect> {
  final TextStyle _styleSelected = GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: StylePresets.cWhite);
  final TextStyle _styleUnselected = GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey.shade100);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: StylePresets.cGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => widget.onChanged(),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: widget.operation == CategoryType.expense ? StylePresets.cRed : StylePresets.cGrey,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        CategoryType.expense.label,
                        style: widget.operation == CategoryType.expense ? _styleSelected : _styleUnselected,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => widget.onChanged(),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: widget.operation == CategoryType.receipt ? StylePresets.cGreen : StylePresets.cGrey,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        CategoryType.receipt.label,
                        style: widget.operation == CategoryType.receipt ? _styleSelected : _styleUnselected,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTypeSelector extends StatefulWidget {
  final CategoryType initialType;
  final ValueChanged<CategoryType> onChanged;

  const TransactionTypeSelector({
    super.key,
    required this.initialType,
    required this.onChanged,
  });

  @override
  State<TransactionTypeSelector> createState() => _TransactionTypeSelectorState();
}

class _TransactionTypeSelectorState extends State<TransactionTypeSelector> {
  late CategoryType _type;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType; // Initialize with given type
  }

  void _changeType(CategoryType type) {
    setState(() => _type = type);
    widget.onChanged(type); // Notify parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _changeType(CategoryType.expense),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _type == CategoryType.expense ? Colors.white.withAlpha(51) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Expense',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _changeType(CategoryType.receipt),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _type == CategoryType.receipt ? Colors.white.withAlpha(51) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Income',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
