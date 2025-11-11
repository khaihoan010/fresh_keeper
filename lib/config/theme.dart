import 'package:flutter/material.dart';

/// Fresh Keeper App Theme Configuration
class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF7DDDC9); // Mint Green
  static const Color secondaryColor = Color(0xFFFFB6C1); // Pink Pastel
  static const Color accentColor = Color(0xFFFF6B6B); // Coral Red

  // Status Colors
  static const Color successColor = Color(0xFF4CAF50); // Green - Fresh (>7 days)
  static const Color warningColor = Color(0xFFFF9800); // Orange - Use soon (3-7 days)
  static const Color errorColor = Color(0xFFF44336); // Red - Urgent (<3 days)

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color backgroundCream = Color(0xFFFFFEF7); // Cream
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light Gray

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF757575);

  // Text Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.21, // 34pt line height / 28pt font size
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.25, // 30pt / 24pt
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3, // 26pt / 20pt
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5, // 24pt / 16pt
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.43, // 20pt / 14pt
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.33, // 16pt / 12pt
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Spacing
  static const double baseUnit = 8.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusFull = 28.0;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: backgroundColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: h2,
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: h1,
        displayMedium: h2,
        displaySmall: h3,
        bodyLarge: body1,
        bodyMedium: body2,
        bodySmall: caption,
        labelLarge: button,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: backgroundColor,
        margin: EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: button,
          padding: EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1),
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: button,
          padding: EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: body2.copyWith(fontWeight: FontWeight.w600),
          padding: EdgeInsets.all(spacing8),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        hintStyle: body1.copyWith(color: textDisabled),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textDisabled,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: backgroundLight,
        selectedColor: primaryColor,
        labelStyle: body2,
        padding: EdgeInsets.symmetric(
          horizontal: spacing12,
          vertical: spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: spacing16,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    );
  }

  // Helper method to get status color based on days until expiry
  static Color getExpiryStatusColor(int daysUntilExpiry) {
    if (daysUntilExpiry > 7) {
      return successColor; // Green - Fresh
    } else if (daysUntilExpiry >= 3) {
      return warningColor; // Orange - Use soon
    } else {
      return errorColor; // Red - Urgent
    }
  }

  // Helper method to get status text
  static String getExpiryStatusText(int daysUntilExpiry) {
    if (daysUntilExpiry > 7) {
      return 'Tươi';
    } else if (daysUntilExpiry >= 3) {
      return 'Sử dụng sớm';
    } else if (daysUntilExpiry > 0) {
      return 'Gấp';
    } else {
      return 'Đã hết hạn';
    }
  }
}
