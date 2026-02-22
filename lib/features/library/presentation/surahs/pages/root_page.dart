import 'package:flutter/material.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_theme.dart';
import 'surah_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(Colors.orange);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onRouteGenerator,
      title: AppStrings.appName,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      home: const SurahPage(),
    );
  }
}
