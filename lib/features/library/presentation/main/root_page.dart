import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../settings/state/app_settings_state.dart';
import 'main_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsState>(
      builder: (context, appSettingsState, _) {
        final appTheme = AppTheme(appSettingsState.themeColor);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onRouteGenerator,
          title: AppStrings.appName,
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: appSettingsState.appThemeMode,
          builder: (context, child) {
            return SafeArea(
              top: false,
              left: false,
              right: false,
              bottom: Platform.isAndroid,
              maintainBottomViewPadding: true,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const MainPage(),
        );
      },
    );
  }
}