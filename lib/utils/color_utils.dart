import 'package:flutter/material.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

extension ColorHandler on Color {
  int toInt() {
    final alpha = (a * 255).toInt();
    final red = (r * 255).toInt();
    final green = (g * 255).toInt();
    final blue = (b * 255).toInt();
    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }
}

class ColorUtils {
  static Color getIconColor(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark ? StylePresets.cWhite : StylePresets.cBlack;
  }
}
