import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kGreen = Color(0xFF4CAF50);
const kDark = Color(0xFF222222);
const kLight = Color(0xFFF6F8F7);
const kAccent = Color(0xFF2ECC71);

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kGreen,
      primary: kGreen,
      secondary: kAccent,
      background: kLight,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: kLight,
    textTheme: GoogleFonts.poppinsTextTheme(
      base.textTheme,
    ).apply(bodyColor: kDark, displayColor: kDark),
    appBarTheme: AppBarTheme(
      backgroundColor: kLight,
      foregroundColor: kDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: kDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
    ),
  );
}
