import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:pobre_simulator/widgets/amount_keyboard.dart';
import 'package:pobre_simulator/widgets/widget_utils.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final String label;
  final bool labelOnLeft;
  final bool enabled;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;
  final int? maxLength;
  final bool password;
  final bool readOnly;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final Function? onPressedSufix;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction textInputAction;
  final FieldStyle fieldStyle;
  final String hint;

  const CustomTextField({
    super.key,
    this.label = '',
    this.labelOnLeft = true,
    this.enabled = true,
    this.inputType = TextInputType.text,
    this.maxLength,
    required this.controller,
    this.password = false,
    this.readOnly = false,
    this.text = '',
    this.validator,
    this.formatters = const [],
    this.suffixIcon,
    this.onPressedSufix,
    this.autovalidateMode,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.fieldStyle = FieldStyle.normal,
    this.hint = '',
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  void _showAmountKeyboard() {
    double initialAmount = 0.0;
    String currentText = widget.controller.text;
    if (currentText.isNotEmpty) {
      currentText = currentText.replaceAll(',', '');
      try {
        currentText = currentText.replaceAll(RegExp(r'[^0-9.]'), '');
        initialAmount = double.parse(currentText);
      } catch (e) {
        initialAmount = 0.0;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AmountKeyboard(
            initialAmount: initialAmount,
            onAmountConfirmed: (amount) {
              setState(() {
                widget.controller.text = NumberFormat.currency(symbol: '').format(amount);
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.inputType == TextInputType.number) {
          _showAmountKeyboard();
        } else {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: widget.readOnly,
                  canRequestFocus: !widget.readOnly,
                  maxLength: widget.maxLength,
                  controller: widget.controller,
                  keyboardType: widget.inputType,
                  style: const TextStyle(color: StylePresets.cBlack),
                  showCursor: false,
                  validator: widget.validator,
                  inputFormatters: widget.formatters,
                  autovalidateMode: widget.autovalidateMode,
                  onChanged: widget.onChanged != null ? (value) => widget.onChanged!(value) : (value) {},
                  textInputAction: widget.textInputAction,
                  decoration: getInputDecoration(label: widget.label, hint: widget.hint),
                  obscureText: widget.password,
                  enabled: widget.enabled,
                ),
              ),
              Visibility(
                visible: widget.suffixIcon != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: IconButton(
                    icon: Icon(widget.suffixIcon),
                    onPressed: widget.onPressedSufix != null ? () async => await widget.onPressedSufix!.call() : () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: StylePresets.cBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDateField extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const CustomDateField({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: StylePresets.cBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          hintText: DateFormat('MMM dd, yyyy').format(_selectedDate),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
