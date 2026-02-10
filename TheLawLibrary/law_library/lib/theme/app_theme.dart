import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:law_library/providers/theme_provider.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color secondaryColor = Color(0xFF6366F1);
  static const Color accentColor = Color(0xFFFBBF24);
  static const Color successColor = Color(0xFF16A34A);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFDC2626);

  // Light theme colors
  static const Color lightBackgroundColor = Color(0xFFF9FAFB);
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightTextColor = Color(0xFF111827);
  static const Color lightSecondaryTextColor = Color(0xFF6B7280);
  static const Color lightDividerColor = Color(0xFFE5E7EB);


  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF111827);
  static const Color darkSurfaceColor = Color(0xFF1F2937);
  static const Color darkTextColor = Color(0xFFF9FAFB);
  static const Color darkSecondaryTextColor = Color(0xFF9CA3AF);
  static const Color darkDividerColor = Color(0xFF374151);

  // Spacing
  static const double baseSpacing2 = 2.0;
  static const double baseSpacing4 = 4.0;
  static const double baseSpacing8 = 8.0;
  static const double baseSpacing12 = 12.0;
  static const double baseSpacing16 = 16.0;
  static const double baseSpacing24 = 24.0;
  static const double baseSpacing32 = 32.0;
  static const double baseSpacing40 = 40.0;
  static const double baseSpacing48 = 48.0;

  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Elevation
  static const double elevationSmall = 1.0;
  static const double elevationMedium = 3.0;
  static const double elevationLarge = 8.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Helper to get dynamic spacing based on UI density
  static double getSpacing(double baseSpacing, UiDensity density) {
    switch (density) {
      case UiDensity.compact:
        return baseSpacing * 0.8; // Reduce spacing for compact mode
      case UiDensity.standard:
        return baseSpacing; // Standard spacing
    }
  }

  // Helper to get dynamic font size based on font size setting
  static double getFontSize(double baseFontSize, AppFontSize size) {
    switch (size) {
      case AppFontSize.small:
        return baseFontSize * 0.9; // Smaller font size
      case AppFontSize.medium:
        return baseFontSize; // Medium font size
      case AppFontSize.large:
        return baseFontSize * 1.1; // Larger font size
    }
  }

  // Text styles
  static TextStyle _getTextStyle(bool isDark) {
    return GoogleFonts.inter(
      color: isDark ? darkTextColor : lightTextColor,
    );
  }

  static TextTheme _getTextTheme(bool isDark, AppFontSize fontSize) {
    final baseStyle = _getTextStyle(isDark);
    final baseColor = isDark ? darkTextColor : lightTextColor;
    final secondaryColor =
        isDark ? darkSecondaryTextColor : lightSecondaryTextColor;

    // Adjust base font sizes based on the selected AppFontSize
    final double displayLargeSize = getFontSize(32, fontSize);
    final double displayMediumSize = getFontSize(28, fontSize);
    final double displaySmallSize = getFontSize(24, fontSize);
    final double headlineLargeSize = getFontSize(22, fontSize);
    final double headlineMediumSize = getFontSize(20, fontSize);
    final double headlineSmallSize = getFontSize(18, fontSize);
    final double titleLargeSize = getFontSize(16, fontSize);
    final double titleMediumSize = getFontSize(16, fontSize);
    final double titleSmallSize = getFontSize(14, fontSize);
    final double bodyLargeSize = getFontSize(16, fontSize);
    final double bodyMediumSize = getFontSize(14, fontSize);
    final double bodySmallSize = getFontSize(12, fontSize);
    final double labelLargeSize = getFontSize(14, fontSize);
    final double labelMediumSize = getFontSize(12, fontSize);
    final double labelSmallSize = getFontSize(11, fontSize);

    return TextTheme(
      displayLarge: baseStyle.copyWith(
          fontSize: displayLargeSize,
          fontWeight: FontWeight.bold,
          color: baseColor),
      displayMedium: baseStyle.copyWith(
          fontSize: displayMediumSize,
          fontWeight: FontWeight.bold,
          color: baseColor),
      displaySmall: baseStyle.copyWith(
          fontSize: displaySmallSize,
          fontWeight: FontWeight.bold,
          color: baseColor),
      headlineLarge: baseStyle.copyWith(
          fontSize: headlineLargeSize,
          fontWeight: FontWeight.w600,
          color: baseColor),
      headlineMedium: baseStyle.copyWith(
          fontSize: headlineMediumSize,
          fontWeight: FontWeight.w600,
          color: baseColor),
      headlineSmall: baseStyle.copyWith(
          fontSize: headlineSmallSize,
          fontWeight: FontWeight.w600,
          color: baseColor),
      titleLarge: baseStyle.copyWith(
          fontSize: titleLargeSize,
          fontWeight: FontWeight.w600,
          color: baseColor),
      titleMedium: baseStyle.copyWith(
          fontSize: titleMediumSize,
          fontWeight: FontWeight.w500,
          color: baseColor),
      titleSmall: baseStyle.copyWith(
          fontSize: titleSmallSize,
          fontWeight: FontWeight.w500,
          color: baseColor),
      bodyLarge: baseStyle.copyWith(
          fontSize: bodyLargeSize, height: 1.5, color: baseColor),
      bodyMedium: baseStyle.copyWith(
          fontSize: bodyMediumSize, height: 1.5, color: baseColor),
      bodySmall: baseStyle.copyWith(
          fontSize: bodySmallSize, height: 1.5, color: secondaryColor),
      labelLarge: baseStyle.copyWith(
          fontSize: labelLargeSize,
          fontWeight: FontWeight.w500,
          color: baseColor),
      labelMedium: baseStyle.copyWith(
          fontSize: labelMediumSize,
          fontWeight: FontWeight.w500,
          color: baseColor),
      labelSmall: baseStyle.copyWith(
          fontSize: labelSmallSize,
          fontWeight: FontWeight.w500,
          color: secondaryColor),
    );
  }

  // Light theme
  static ThemeData lightTheme(ThemeProvider themeProvider) {
    final uiDensity = themeProvider.uiDensity;
    final fontSize = themeProvider.fontSize;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: lightSurfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurfaceColor,
        foregroundColor: lightTextColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: lightSurfaceColor,
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightSecondaryTextColor,
        elevation: elevationMedium,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: lightDividerColor,
        thickness: 1,
        space: 1,
      ),
      textTheme: _getTextTheme(false, fontSize),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: lightDividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: lightDividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: getSpacing(16, uiDensity),
            horizontal: getSpacing(16, uiDensity)),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
              vertical: getSpacing(16, uiDensity),
              horizontal: getSpacing(24, uiDensity)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                getSpacing(borderRadiusMedium, uiDensity)),
          ),
        ),
      ),
    );
  }

  // Dark theme
  static ThemeData darkTheme(ThemeProvider themeProvider) {
    final uiDensity = themeProvider.uiDensity;
    final fontSize = themeProvider.fontSize;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: darkSurfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurfaceColor,
        foregroundColor: darkTextColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: darkSurfaceColor,
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkSecondaryTextColor,
        elevation: elevationMedium,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: darkDividerColor,
        thickness: 1,
        space: 1,
      ),
      textTheme: _getTextTheme(true, fontSize),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: darkDividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: darkDividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: getSpacing(16, uiDensity),
            horizontal: getSpacing(16, uiDensity)),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(getSpacing(borderRadiusMedium, uiDensity)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
              vertical: getSpacing(16, uiDensity),
              horizontal: getSpacing(24, uiDensity)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                getSpacing(borderRadiusMedium, uiDensity)),
          ),
        ),
      ),
    );
  }
}


