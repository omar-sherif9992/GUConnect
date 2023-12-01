import 'package:GUConnect/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomTheme {

  

  static ThemeData get lightTheme {
    final lightColorScheme = ColorScheme(
      
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.light,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    );
    const TextTheme textTheme =  TextTheme(
        displayMedium: TextStyle(fontFamily: 'Poppins'),
        displaySmall: TextStyle(fontFamily: 'Poppins'),
        displayLarge: TextStyle(fontFamily: 'Poppins'),
        headlineLarge: TextStyle(fontFamily: 'Poppins'),
        headlineMedium: TextStyle(fontFamily: 'Poppins'),
        headlineSmall: TextStyle(fontFamily: 'Poppins'),
        titleLarge: TextStyle(fontFamily: 'Poppins'),
        titleMedium: TextStyle(fontFamily: 'Poppins'),
        titleSmall: TextStyle(fontFamily: 'Poppins'),
        bodyLarge: TextStyle(fontFamily: 'Poppins'),
        bodyMedium: TextStyle(fontFamily: 'Poppins'),
        bodySmall: TextStyle(fontFamily: 'Poppins'),
        labelLarge: TextStyle(fontFamily: 'Poppins'),
        labelMedium: TextStyle(fontFamily: 'Poppins'),
        labelSmall: TextStyle(fontFamily: 'Poppins'),
  );

    return ThemeData(
      primarySwatch: Colors.deepOrange,
      textTheme: textTheme
      ).copyWith(useMaterial3: true, colorScheme: lightColorScheme);
  }

  static ThemeData get darkTheme {
    final darkColorScheme = ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        background: AppColors.dark,
        onBackground: Colors.white,
        surface: AppColors.dark,
        onSurface: Colors.white);

    return ThemeData()
        .copyWith(useMaterial3: true, colorScheme: darkColorScheme);
  }
}
