import 'package:flutter/material.dart';
import 'package:quran/features/library/data/arguments/mushaf_page_detail_args.dart';

import '../../features/library/presentation/hizb/pages/hizbs_page.dart';
import '../../features/reader/pages/mushaf_page_detail.dart';
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
    NamesRouter.pageSurahDetail: (context, args) {
      final MushafPageDetailArgs mushafPageArgs = MushafPageDetailArgs(pageNumber: args.pageNumber);
      return MushafPageDetail(pageNumber: mushafPageArgs.pageNumber,);
    },
    NamesRouter.pageAllHizbs: (context, args) => const HizbsPage(),
  };
}
