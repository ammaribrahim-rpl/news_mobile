import 'package:flutter/material.dart';

class MainColors {
  MainColors._();

  // 🌈 Primary brand colors
  static const MaterialColor primaryColor = MaterialColor(0xFF5E35B1, {
    200: Color(0xFFB39DDB), // Light Lavender Purple
    400: Color(0xFF7E57C2), // Medium Purple
    600: Color(0xFF673AB7), // Purple
    800: Color(0xFF4527A0), // Dark Rich Purple
  });

  // ⚪ Neutral greys
  static const MaterialColor greyColor = MaterialColor(0xFF888888, {
    200: Color(0xFFF5F5F5), // Very Light Grey → bg light
    400: Color(0xFFBDBDBD), // Light-Medium Grey
    600: Color(0xFF888888), // Medium Grey → text/icons
    800: Color(0xFF333333), // Dark Grey → text
  });

  // ⚫ Dark shades
  static const MaterialColor blackColor = MaterialColor(0xFF000000, {
    200: Color(0xFF999999), // Greyish Black
    400: Color(0xFF666666), 
    600: Color(0xFF444444),
    800: Color(0xFF222222), // Deep Black → dark mode bg
  });

  // ⚪ Light shades
  static const MaterialColor whiteColor = MaterialColor(0xFFFFFFFF, {
    200: Color(0xFFF5F5F5), // Almost White → light bg
    400: Color(0xFFE0E0E0),
    600: Color(0xFFCCCCCC),
    800: Color(0xFFB8B8B8),
  });

  // ✨ Common surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF); // card / scaffold light
  static const Color surfaceDark  = Color(0xFF121212); // card / scaffold dark

  // 📝 Text colors
  static const Color textLight = Color(0xFF111111);
  static const Color textDark  = Color(0xFFF5F5F5);
}