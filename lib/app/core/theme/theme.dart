import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A56DB);
  static const Color secondary = Color(0xFFE8F0FE);
  static const Color error = Color(0xFFFF5963);
  static const Color success = Color(0xFF249689);
  static const Color warning = Color(0xFFF9CF58);

  static const Color primaryBackground = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF5F7FA);
  static const Color inputBackground = Color(0xFFF6F6F9);
  static const Color border = Color(0xFFEBEBF3);

  static const Color textPrimary = Color(0xFF0F0F1C);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
}

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.surface,
    required this.surfaceContainer,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.inputBackground,
  });

  final Color surface;
  final Color surfaceContainer;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color inputBackground;

  static const light = AppSemanticColors(
    surface: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFF5F7FA),
    textPrimary: Color(0xFF0F0F1C),
    textSecondary: Color(0xFF6B7280),
    border: Color(0xFFEBEBF3),
    inputBackground: Color(0xFFF6F6F9),
  );

  static const dark = AppSemanticColors(
    surface: Color(0xFF0F0F1C),
    surfaceContainer: Color(0xFF1A1A2E),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9CA3AF),
    border: Color(0xFF2D2D45),
    inputBackground: Color(0xFF1A1A2E),
  );

  @override
  AppSemanticColors copyWith({
    Color? surface,
    Color? surfaceContainer,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? inputBackground,
  }) {
    return AppSemanticColors(
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      inputBackground: inputBackground ?? this.inputBackground,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        extensions: const [AppSemanticColors.light],
        scaffoldBackgroundColor: AppColors.primaryBackground,
        dividerColor: AppColors.border,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        extensions: const [AppSemanticColors.dark],
        scaffoldBackgroundColor: const Color(0xFF0F0F1C),
        dividerColor: const Color(0xFF2D2D45),
      );
}

const double kBreakpointWide = 800.0;
const double kFormMaxWidth = 600.0;
const double kDefaultMargin = 20.0;
