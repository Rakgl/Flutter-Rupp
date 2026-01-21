import 'package:flutter/material.dart';

/// Defines the color palette for the App UI Kit.
abstract class AppColors {
  // --- Core Base Colors ---
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
  static const Color scaffoldBackground = Color(0xFFF5F8FC);
  static const Color darkBackground = Color(0xFF191C1D);

  // --- Primary Aqua/Blue Palette ---
  static const Color primaryColor = Color(0xFFED6B65); // Brand Red
  static const Color blueLight = Color(0xFF9ADDFE);
  static const Color skyBlue = Color(0xFF0175C2);
  static const Color oceanBlue = Color(0xFF02569B);
  static const Color crystalBlue = Color(0xFF55ACEE);
  static const Color confirmedColor = Color(0xFF3685EB);
  static const Color surface2 = Color(0xFFEBF2F7); // Light blue tint

  // --- Neutrals & Greys ---
  static const MaterialColor grey = Colors.grey;
  static const Color lightBlack = Colors.black54;
  static const Color liver = Color(0xFF4D4D4D);
  static const Color paleSky = Color(0xFF73777F); // Subtitle text
  static const Color brightGrey = Color(0xFFEAEAEA); // Dividers/Progress tracks
  static const Color eerieBlack = Color(0xFF191C1D); // Main headings
  static const Color pastelGrey = Color(0xFFCCCCCC);
  
  // --- Input & Interactive States ---
  static const Color inputHover = Color(0xFFE4E4E4);
  static const Color inputFocused = Color(0xFFD1D1D1);
  static const Color inputEnabled = Color(0xFFEDEDED);

  // --- Status & Semantic Colors ---
/// Used for positive growth percentages and successful progress bars (Green)
  static const Color growthSuccess = Color(0xFF28A745); 
  static const Color trendPositive = growthSuccess;

  /// Used for stars and the overall rating breakdown (Yellow/Gold)
  static const Color ratingActive = Color(0xFFFFC107);   
  static const Color ratingPrimary = ratingActive;

  /// Used for warnings or caution indicators (Orange)
  static const Color warningAccent = Color(0xFFFF9800);  

  /// Used for negative growth trends and declined jobs (Red)
  static const Color trendNegative = Color(0xFFFF0000);
  
  static const MaterialColor green = Colors.green;
  static const MaterialColor red = Colors.red;
  static const Color redWine = Color(0xFFC70025);

  // --- Secondary (Purple/Pink) Palette ---
  static const MaterialColor secondary = MaterialColor(0xFF963F6E, <int, Color>{
    50: Color(0xFFFFECF3), // Insight Background
    100: Color(0xFFFFD8E9),
    200: Color(0xFFFFAFD6),
    300: Color(0xFFF28ABE),
    400: Color(0xFFD371A3),
    500: Color(0xFFB55788),
    600: Color(0xFF963F6E), // Insight Text/Border
    700: Color(0xFF7A2756),
    800: Color(0xFF5F0F40),
    900: Color(0xFF3D0026),
  });

  // --- Emphasis & Transparency ---
  static const Color highEmphasisSurface = Color(0xE6000000);
  static const Color mediumEmphasisSurface = Color(0x99000000);
  static const Color borderOutline = Color(0x33000000);
}
