import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/settings/state/app_settings_state.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/mushaf_font_loader.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/repositories/ayah_word_repository_impl.dart';
import '../../data/repositories/hizb_repository_impl.dart';
import '../../data/repositories/juz_repository_impl.dart';
import '../../data/repositories/layout_repository_impl.dart';
import '../../data/repositories/mushaf_page_meta_repository_impl.dart';
import '../../data/repositories/surah_name_repository_impl.dart';
import '../../domain/usecases/ayah_word_use_case.dart';
import '../../domain/usecases/hizb_use_case.dart';
import '../../domain/usecases/juz_use_case.dart';
import '../../domain/usecases/layout_use_case.dart';
import '../../domain/usecases/mushaf_page_meta_use_case.dart';
import '../../domain/usecases/surah_name_use_case.dart';
import '../state/hizb_state.dart';
import '../state/juz_state.dart';
import '../state/main_state.dart';
import '../state/mushaf_page_meta_state.dart';
import '../state/surah_state.dart';
import 'main_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettingsState>(
          create: (_) => AppSettingsState(),
        ),
        Provider<QuranDatabaseService>(
          create: (_) => QuranDatabaseService.instance,
        ),
        Provider<MushafFontLoader>(
          create: (_) => MushafFontLoader.instance,
        ),

        ChangeNotifierProvider<MainState>(
          create: (_) => MainState(),
        ),

        Provider<AyahWordRepositoryImpl>(
          create: (context) => AyahWordRepositoryImpl(
            context.read<QuranDatabaseService>(),
          ),
        ),
        Provider<JuzRepositoryImpl>(
          create: (context) => JuzRepositoryImpl(
            context.read<QuranDatabaseService>(),
          ),
        ),
        Provider<HizbRepositoryImpl>(
          create: (context) => HizbRepositoryImpl(
            context.read<QuranDatabaseService>(),
          ),
        ),
        Provider<LayoutRepositoryImpl>(
          create: (context) => LayoutRepositoryImpl(
            context.read<QuranDatabaseService>(),
          ),
        ),
        Provider<SurahNameRepositoryImpl>(
          create: (context) => SurahNameRepositoryImpl(
            context.read<QuranDatabaseService>(),
          ),
        ),
        Provider<MushafPageMetaRepositoryImpl>(
          create: (context) => MushafPageMetaRepositoryImpl(
            context.read<QuranDatabaseService>(),
          ),
        ),

        Provider<AyahWordUseCase>(
          create: (context) => AyahWordUseCase(
            context.read<AyahWordRepositoryImpl>(),
          ),
        ),
        Provider<JuzUseCase>(
          create: (context) => JuzUseCase(
            context.read<JuzRepositoryImpl>(),
          ),
        ),
        Provider<HizbUseCase>(
          create: (context) => HizbUseCase(
            context.read<HizbRepositoryImpl>(),
          ),
        ),
        Provider<LayoutUseCase>(
          create: (context) => LayoutUseCase(
            context.read<LayoutRepositoryImpl>(),
          ),
        ),
        Provider<SurahNameUseCase>(
          create: (context) => SurahNameUseCase(
            context.read<SurahNameRepositoryImpl>(),
          ),
        ),
        Provider<MushafPageMetaUseCase>(
          create: (context) => MushafPageMetaUseCase(
            context.read<MushafPageMetaRepositoryImpl>(),
          ),
        ),

        ChangeNotifierProvider<SurahState>(
          lazy: false,
          create: (context) => SurahState(
            context.read<SurahNameUseCase>(),
          )..loadAllSurahs(),
        ),
        ChangeNotifierProvider<JuzState>(
          lazy: false,
          create: (context) => JuzState(
            context.read<JuzUseCase>(),
          )..loadAllJuzs(),
        ),
        ChangeNotifierProvider<HizbState>(
          lazy: false,
          create: (context) => HizbState(
            context.read<HizbUseCase>(),
          )..loadAllHizbs(),
        ),
        ChangeNotifierProvider<MushafPageMetaState>(
          lazy: false,
          create: (context) => MushafPageMetaState(
            context.read<MushafPageMetaUseCase>(),
          )..loadAllPagesMeta(),
        ),
      ],
      child: Consumer<AppSettingsState>(
        builder: (context, appSettingsState, _) {
          final appTheme = AppTheme(appSettingsState.themeColor);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.onRouteGenerator,
            title: AppStrings.appName,
            theme: appTheme.lightTheme,
            darkTheme: appTheme.darkTheme,
            themeMode: appSettingsState.appThemeMode,
            home: const MainPage(),
          );
        },
      ),
    );
  }
}
