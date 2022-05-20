import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData = ThemeData(
  backgroundColor: ColorManager.whiteColor,
  primaryColor: ColorManager.mainBlue,
  iconTheme: const IconThemeData(color: ColorManager.darkGrey, size: 30),
  brightness: Brightness.light,
  primaryColorDark: ColorManager.darkGrey,
  primaryColorLight: ColorManager.darkGrey,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(ColorManager.darkGrey),
    foregroundColor: MaterialStateProperty.all(ColorManager.darkWhite),
  )),
  textTheme: _textTheme,
  colorScheme: const ColorScheme(
    background: ColorManager.darkGrey,
    onSurface: ColorManager.lightBlue,
    onPrimary: ColorManager.darkGrey,
    secondary: ColorManager.lightBlue,
    primary: ColorManager.darkGrey,
    surface: ColorManager.darkWhite,
    error: ColorManager.whiteColor,
    onBackground: ColorManager.darkWhite,
    onError: ColorManager.lightGrey,
    brightness: Brightness.light,
    onSecondary: ColorManager.darkWhite,
  ),
);

class ColorManager {
  static const Color mainBlue = Color(0xff2666CF);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Color(0xFF2C3333);
  static const Color lightBlue = Color(0xFF30AADD);
  static const Color darkWhite = Color(0xFFEEEEEE);
  static const Color darkGrey = Color.fromRGBO(64, 64, 64, 1);
  static const Color lightGrey = Color.fromRGBO(175, 175, 175, 1.0);
}

final TextTheme _textTheme = TextTheme(
  headline1: GoogleFonts.poppins(
      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
  headline2: GoogleFonts.poppins(
      fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
  headline3: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
  headline4: GoogleFonts.roboto(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
  subtitle1:
      GoogleFonts.alegreyaSans(fontSize: 16, fontWeight: FontWeight.w500),
  subtitle2: GoogleFonts.roboto(
      fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),
  button: GoogleFonts.alegreyaSans(fontSize: 16, fontWeight: FontWeight.w500),
  caption: GoogleFonts.alegreyaSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: ColorManager.darkGrey),
  overline: GoogleFonts.alegreyaSans(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
