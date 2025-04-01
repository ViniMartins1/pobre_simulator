import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: StylePresets.cWhite,
    colorScheme: ColorScheme.light(
      surface: StylePresets.cWhite,
      primary: StylePresets.cPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.bold,
        color: StylePresets.cBlack,
        fontSize: 22,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: StylePresets.cPrimaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  );

  static void applyStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: StylePresets.cPrimaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
