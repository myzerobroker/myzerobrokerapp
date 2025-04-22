import 'package:flutter/material.dart';

class ColorsPalette {
  // Primary Colors
  static const Color primaryColor = Color(0xFF323594); // Purple
  static const Color secondaryColor = Color(0xFFd6d8ea); // Light Gray-Blue
  static const Color bgColor = Color(0xFFeef1f7); // Light Background
  static const Color cardBgColor = Color(0xFFFFFFFF); // White for cards
  static const Color textPrimaryColor = Color(0xFF2c2c2c); // Dark Text
  static const Color textSecondaryColor = Color(0xFF757575); // Light Text
  static const Color starColor = Color(0xFFFFD700); // Gold for ratings
  static const Color iconColor = Color(0xFF757575); // Icon tint
  static const Color appBarColor = Color(0xFFeef1f7); // Light AppBar Background
}

class TextStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: ColorsPalette.textPrimaryColor,
  );
  
  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: ColorsPalette.textPrimaryColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: ColorsPalette.textSecondaryColor,
  );
  
  static const TextStyle priceStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ColorsPalette.textPrimaryColor,
  );
  
  static const TextStyle buttonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 80, 14, 14),
   
  );
}

class ThemeConfig {
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: ColorsPalette.primaryColor,
      scaffoldBackgroundColor: ColorsPalette.bgColor,
      cardColor: ColorsPalette.cardBgColor,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsPalette.appBarColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyles.headingStyle,
        headlineMedium: TextStyles.subHeadingStyle,
        bodyMedium: TextStyles.bodyStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorsPalette.primaryColor),
          foregroundColor: MaterialStateProperty.all(ColorsPalette.cardBgColor),
          textStyle: MaterialStateProperty.all(TextStyles.buttonStyle),
        ),
      ),
    );
  }
}