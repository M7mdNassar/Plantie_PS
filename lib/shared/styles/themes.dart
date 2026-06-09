import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// MODERN LIGHT THEME - Inspired by trending apps 2024
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    tertiary: AppColors.tertiary,
    surface: AppColors.lightSurface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.lightText,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,

  // APP BAR - Modern floating style
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    surfaceTintColor: AppColors.lightBackground,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: 'jannah',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primary,
      size: 24,
    ),
  ),

  // BOTTOM NAV - Modern rounded style
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightSurface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.lightTextTertiary,
    elevation: 12,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: false,
  ),

  // TEXT THEME - Accessible with scale support
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextSecondary,
      fontFamily: 'jannah',
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextTertiary,
      fontFamily: 'jannah',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
      fontFamily: 'jannah',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextSecondary,
      fontFamily: 'jannah',
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
      fontFamily: 'jannah',
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
      fontFamily: 'jannah',
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
      fontFamily: 'jannah',
    ),
  ),

  // BUTTONS - Modern with enhanced elevation
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: AppColors.primary.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      minimumSize: const Size(double.infinity, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontFamily: 'jannah',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontFamily: 'jannah',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      minimumSize: const Size(double.infinity, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontFamily: 'jannah',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  // INPUT FIELDS - Modern with border radius
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightSurfaceVariant,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(
      color: AppColors.lightTextTertiary,
      fontFamily: 'jannah',
      fontSize: 14,
    ),
    labelStyle: const TextStyle(
      color: AppColors.lightTextSecondary,
      fontFamily: 'jannah',
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    prefixIconColor: AppColors.primary,
    suffixIconColor: AppColors.primary,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.error, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // CARDS
  cardTheme: CardThemeData(
    color: AppColors.lightSurface,
    elevation: 2,
    shadowColor: AppColors.shadowColorLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(8),
  ),

  // DIALOGS
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.lightSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 8,
  ),

  // FLOATING ACTION BUTTON
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 6,
    highlightElevation: 12,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // CHIP
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.lightSurfaceVariant,
    selectedColor: AppColors.primary,
    labelStyle: const TextStyle(
      color: AppColors.lightText,
      fontFamily: 'jannah',
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  fontFamily: 'jannah',
);

/// MODERN DARK THEME - Inspired by trending apps 2024
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryLight,  // Lighter primary in dark mode
    secondary: AppColors.secondaryLight,
    tertiary: AppColors.tertiaryLight,
    surface: AppColors.darkSurface,
    error: AppColors.error,
    onPrimary: AppColors.darkBackground,
    onSecondary: AppColors.darkBackground,
    onSurface: AppColors.darkText,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,

  // APP BAR - Modern floating style
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    surfaceTintColor: AppColors.darkSurface,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: 'jannah',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primaryLight,
      size: 24,
    ),
  ),

  // BOTTOM NAV
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: AppColors.darkTextTertiary,
    elevation: 12,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: false,
  ),

  // TEXT THEME
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextSecondary,
      fontFamily: 'jannah',
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextTertiary,
      fontFamily: 'jannah',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkText,
      fontFamily: 'jannah',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextSecondary,
      fontFamily: 'jannah',
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
      fontFamily: 'jannah',
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
      fontFamily: 'jannah',
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
      fontFamily: 'jannah',
    ),
  ),

  // BUTTONS
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.darkBackground,
      elevation: 4,
      shadowColor: AppColors.primaryLight.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      minimumSize: const Size(double.infinity, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontFamily: 'jannah',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontFamily: 'jannah',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      side: const BorderSide(color: AppColors.primaryLight, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      minimumSize: const Size(double.infinity, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontFamily: 'jannah',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  // INPUT FIELDS
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurfaceVariant,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(
      color: AppColors.darkTextTertiary,
      fontFamily: 'jannah',
      fontSize: 14,
    ),
    labelStyle: const TextStyle(
      color: AppColors.darkTextSecondary,
      fontFamily: 'jannah',
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    prefixIconColor: AppColors.primaryLight,
    suffixIconColor: AppColors.primaryLight,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.error, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // CARDS
  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    elevation: 2,
    shadowColor: AppColors.shadowColorDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(8),
  ),

  // DIALOGS
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.darkSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 8,
  ),

  // FLOATING ACTION BUTTON
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryLight,
    foregroundColor: AppColors.darkBackground,
    elevation: 6,
    highlightElevation: 12,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // CHIP
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.darkSurfaceVariant,
    selectedColor: AppColors.primaryLight,
    labelStyle: const TextStyle(
      color: AppColors.darkText,
      fontFamily: 'jannah',
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  fontFamily: 'jannah',
);
