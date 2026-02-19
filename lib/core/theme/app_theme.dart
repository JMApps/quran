import 'package:flutter/material.dart';

class AppTheme {
  final Color _appColor;

  AppTheme(this._appColor);

  ThemeData get lightTheme => _buildTheme(Brightness.light);

  ThemeData get darkTheme => _buildTheme(Brightness.dark);

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: _appColor,
    );
    return ThemeData(
      fontFamily: 'Gilroy',
      fontFamilyFallback: const [
        // AppStringConstraints.fontFour,
        // AppStringConstraints.fontFive,
      ],
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            width: 1.0,
            color: colorScheme.primary,
          ),
        ),
        textStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )
      )
    );
  }
}
