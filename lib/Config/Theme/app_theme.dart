import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.cardBackground, // <-- aquí
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dNav,
      titleTextStyle: TextStyle(color: AppColors.appBar, fontSize: 20),
      iconTheme: IconThemeData(color: AppColors.appBar),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.selectedNav,
      selectedItemColor: AppColors.appBar,
      unselectedItemColor: AppColors.unselectedNav,
    ),
  );
}

class AppColors {
  static const Color primary = Color(0xFFE53935); // Rojo
  static const Color background = Color(0xFFF5F5F5); // Gris claro
  static const Color appBar = Color(0xFF424242); // Gris oscuro
  static const Color bottomNav = Color(0xFF424242);
  static const Color selectedNav = Colors.white;
  static const Color unselectedNav = Colors.grey;
  static const Color cardBackground = Colors.white;
  static const Color dNav = Color(0xFFF5F5F5); // Equivalente a Colors.grey[100]
}
