import 'package:flutter/material.dart';

import '../strings/app_strings.dart';
import 'app_styles.dart';

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
      fontFamily: AppStrings.fontGilroy,
      fontFamilyFallback: const [
        AppStrings.fontSFPro,
      ],
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        dragHandleSize: Size(100, 4),
        showDragHandle: true,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppStyles.mainBorder,
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
    );
  }
}
