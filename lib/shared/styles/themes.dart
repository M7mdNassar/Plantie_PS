import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ThemeData().colorScheme.copyWith(primary: plantieColor),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: 'jannah',
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: plantieColor,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodySmall: TextStyle(fontSize: 12.0, color: Colors.black54),
    labelMedium: TextStyle(fontSize: 18.0, color: Colors.black54),
    labelSmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    labelLarge: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: plantieColor,
    ),
    titleMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      height: 1.3,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      color: Colors.grey[600],
    ),
    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      height: 1.3,
    ),
  ),
  fontFamily: 'jannah',
  iconTheme: IconThemeData(
    color: Colors.white,
    size: 30,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: plantieColor,
      elevation: 5.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      minimumSize: const Size(double.infinity, 50),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    prefixIconColor: plantieColor,
    suffixIconColor: plantieColor,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: plantieColor),
      borderRadius: BorderRadius.circular(8.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ThemeData().colorScheme.copyWith(primary: plantieColor),
  scaffoldBackgroundColor: HexColor('333739'),
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: 'jannah',
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: plantieColor,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: HexColor('333739'),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodySmall: TextStyle(fontSize: 12.0, color: Colors.white54),
    labelSmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    labelMedium: TextStyle(fontSize: 18.0, color: Colors.white54),
    labelLarge: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: plantieColor,
    ),
    titleMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.3,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      color: Colors.grey[400],
    ),
    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      height: 1.3,
    ),
  ),
  fontFamily: 'jannah',
  iconTheme: IconThemeData(
    color: Colors.white,
    size: 30,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: plantieColor,
      elevation: 5.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      minimumSize: const Size(double.infinity, 50),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    prefixIconColor: plantieColor,
    suffixIconColor: plantieColor,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: plantieColor),
      borderRadius: BorderRadius.circular(8.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  ),
);
