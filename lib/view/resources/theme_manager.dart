import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData = ThemeData(
  backgroundColor: ColorManager.backGroundBlue,
  scaffoldBackgroundColor: ColorManager.backGroundBlue,
  appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: _textTheme.headline2,
      foregroundColor: ColorManager.foreGroundGrey,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white.withOpacity(0),
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark)),
  primaryTextTheme: _textTheme,
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
    background: ColorManager.backGroundBlue,
    onSurface: ColorManager.foreGroundBlue,
    onBackground: ColorManager.foreGroundGrey,
    onSecondary: ColorManager.whiteColor,
    // till here
    onPrimary: ColorManager.darkGrey,
    secondary: ColorManager.lightBlue,
    primary: ColorManager.darkGrey,
    surface: ColorManager.darkWhite,
    error: ColorManager.whiteColor,
    onError: ColorManager.lightGrey,
    brightness: Brightness.light,
  ),
);

class ColorManager {
  static const Color foreGroundGrey = Color(0xff939094);
  static const Color foreGroundBlue = Color(0xff2D8EFF);

  static const Color backGroundBlue = Color(0xffCAD6DE);

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
      //used
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: ColorManager.foreGroundGrey),
  headline3: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: ColorManager.foreGroundGrey),
  headline4: GoogleFonts.roboto(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
  subtitle1: GoogleFonts.alegreyaSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: ColorManager.foreGroundGrey),
  subtitle2: GoogleFonts.roboto(
      fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),
  button: GoogleFonts.alegreyaSans(fontSize: 16, fontWeight: FontWeight.w500),
  caption: GoogleFonts.alegreyaSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: ColorManager.darkGrey),
  overline: GoogleFonts.alegreyaSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: Colors.black),
);
