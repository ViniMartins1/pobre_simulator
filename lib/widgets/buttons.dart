import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class BottomButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  final bool enabled;
  const BottomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style = GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: StylePresets.cWhite,
    );

    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () async {
          if (enabled) await onPressed.call();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: enabled ? StylePresets.cBlack : StylePresets.cGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}

class FlashButton extends StatelessWidget {
  const FlashButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: StylePresets.cWhiteAccent,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: StylePresets.cWhite,
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: StylePresets.cWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 8, 24, 24),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: StylePresets.cBlack,
          foregroundColor: StylePresets.cWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
