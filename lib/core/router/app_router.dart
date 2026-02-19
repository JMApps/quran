import 'package:flutter/material.dart';

import '../../features/library/presentation/layout/pages/layout_line_page.dart';
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
    NamesRouter.pageLayoutLine: (context, args) =>
        LayoutLinePage(pageNumber: args as int),
  };
}
