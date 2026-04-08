import 'package:flutter/material.dart';

import '../../features/library/presentation/hizb/pages/hizbs_page.dart';
import '../../features/reader/pages/surah_detail_page.dart';
import 'names_router.dart';

class AppRouter {
  static Route<dynamic> onRouteGenerator(RouteSettings routeSettings) {
    final builder = routes[routeSettings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) {
          return builder(context, routeSettings.arguments);
        },
      );
    }
    throw Exception('Invalid route');
  }

  static Map<String, Widget Function(BuildContext, dynamic)> routes = {
    NamesRouter.pageSurahDetail: (context, args) => SurahDetailPage(currentMushafPage: args as int),
    NamesRouter.pageAllHizbs: (context, args) => const HizbsPage(),
  };
}
