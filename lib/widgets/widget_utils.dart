import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

enum FieldStyle { normal, simple }

TextStyle textFieldStyle = GoogleFonts.nunito(color: StylePresets.cBlack, fontSize: 18);

InputDecoration getInputDecoration({
  required String label,
  String hint = '',
  FieldStyle fieldStyle = FieldStyle.normal,
  String? errorText,
  Widget? pIcon,
  Widget? sIcon,
}) {
  final border = OutlineInputBorder(
    gapPadding: 2,
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: StylePresets.cBlack,
      width: 1,
    ),
  );

  final errorBorder = OutlineInputBorder(
    gapPadding: 2,
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: StylePresets.cRed,
      width: 2,
    ),
  );

  if (fieldStyle == FieldStyle.normal) {
    return InputDecoration(
      filled: true,
      labelText: label,
      hintStyle: textFieldStyle,
      hintText: hint,
      fillColor: StylePresets.cWhite,
      prefixIcon: fieldStyle == FieldStyle.simple ? pIcon : null,
      suffixIcon: fieldStyle == FieldStyle.simple ? sIcon : null,
      enabledBorder: border,
      border: border,
      focusedErrorBorder: errorBorder,
      errorBorder: errorBorder,
      errorText: (errorText == null || errorText.isNotEmpty) ? errorText : ' ',
      errorStyle: const TextStyle(fontSize: 0, height: 2), // Hides error text but prevents shrinking
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  } else {
    return InputDecoration(
      labelText: label,
      hintStyle: textFieldStyle,
      errorText: errorText,
      errorStyle: const TextStyle(height: 0, color: StylePresets.cTransparent),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }
}
