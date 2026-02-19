import 'package:flutter/material.dart';
import 'package:quran/core/router/app_router.dart';

import '../../../../../core/theme/app_theme.dart';
import 'surah_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(Colors.brown);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onRouteGenerator,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      home: const SurahPage(),
    );
  }
}
