import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/main_state.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/repositories/juz_repository_impl.dart';
import '../../data/repositories/layout_repository_impl.dart';
import '../../data/repositories/surah_name_repository_impl.dart';
import '../../data/repositories/ayah_word_repository_impl.dart';
import '../../domain/usecases/get_page_word_use_case.dart';
import '../state/mushaf_reader_state.dart';
import '../state/surah_state.dart';
import 'main_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(Colors.blue);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainState()),
        Provider.value(value: QuranDatabaseService.instance),

        Provider(create: (c) => LayoutRepositoryImpl(c.read<QuranDatabaseService>())),
        Provider(create: (c) => AyahWordRepositoryImpl(c.read<QuranDatabaseService>())),
        Provider(create: (c) => SurahNameRepositoryImpl(c.read<QuranDatabaseService>())),
        Provider(create: (c) => JuzRepositoryImpl(c.read<QuranDatabaseService>())),

        Provider(create: (c) => GetMushafPageUseCase(
          c.read<LayoutRepositoryImpl>(),
          c.read<AyahWordRepositoryImpl>(),
          c.read<SurahNameRepositoryImpl>(),
          c.read<JuzRepositoryImpl>(),
        )),

        ChangeNotifierProvider(create: (c) => MushafReaderState(c.read<GetMushafPageUseCase>())),
        ChangeNotifierProvider(create: (_) => SurahState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onRouteGenerator,
        title: AppStrings.appName,
        theme: appTheme.lightTheme,
        darkTheme: appTheme.darkTheme,
        home: const MainPage(),
      ),
    );
  }
}
