import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/mushaf_font_loader.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_theme.dart';

import '../../data/repositories/ayah_word_repository_impl.dart';
import '../../data/repositories/hizb_repository_impl.dart';
import '../../data/repositories/juz_repository_impl.dart';
import '../../data/repositories/layout_repository_impl.dart';
import '../../data/repositories/surah_name_repository_impl.dart';
import '../../data/repositories/mushaf_repository_impl.dart';

import '../../domain/usecases/ayah_word_use_case.dart';
import '../../domain/usecases/hizb_use_case.dart';
import '../../domain/usecases/juz_use_case.dart';
import '../../domain/usecases/layout_use_case.dart';
import '../../domain/usecases/mushaf_page_use_case.dart';
import '../../domain/usecases/mushaf_use_case.dart';
import '../../domain/usecases/surah_name_use_case.dart';

import '../state/main_state.dart';
import '../state/surah_state.dart';
import 'main_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(Colors.blue);

    return MultiProvider(
      providers: [
        // 1) DB service
        Provider<QuranDatabaseService>(
          create: (_) => QuranDatabaseService.instance,
        ),

        // 2) States
        ChangeNotifierProvider(create: (_) => MainState()),
        ChangeNotifierProvider(create: (_) => SurahState()),

        Provider<MushafFontLoader>(
          create: (_) => MushafFontLoader.instance,
        ),

        // 3) Repositories (ВАЖНО: сначала они)
        Provider<AyahWordRepositoryImpl>(
          create: (c) => AyahWordRepositoryImpl(c.read<QuranDatabaseService>()),
        ),
        Provider<JuzRepositoryImpl>(
          create: (c) => JuzRepositoryImpl(c.read<QuranDatabaseService>()),
        ),
        Provider<HizbRepositoryImpl>(
          create: (c) => HizbRepositoryImpl(c.read<QuranDatabaseService>()),
        ),
        Provider<LayoutRepositoryImpl>(
          create: (c) => LayoutRepositoryImpl(c.read<QuranDatabaseService>()),
        ),
        Provider<SurahNameRepositoryImpl>(
          create: (c) => SurahNameRepositoryImpl(c.read<QuranDatabaseService>()),
        ),

        // Если MushafPageRepository тебе реально нужен (ты говорил, что он дублирует),
        // то оставь; если нет — лучше удалить и usecase тоже.
        Provider<MushafRepositoryImpl>(
          create: (c) => MushafRepositoryImpl(c.read<QuranDatabaseService>()),
        ),

        // 4) UseCases
        Provider(create: (c) => AyahWordUseCase(c.read<AyahWordRepositoryImpl>())),
        Provider(create: (c) => JuzUseCase(c.read<JuzRepositoryImpl>())),
        Provider(create: (c) => HizbUseCase(c.read<HizbRepositoryImpl>())),
        Provider(create: (c) => LayoutUseCase(c.read<LayoutRepositoryImpl>())),
        Provider(create: (c) => SurahNameUseCase(c.read<SurahNameRepositoryImpl>())),

        Provider(create: (c) => MushafPageUseCase(c.read<MushafRepositoryImpl>())),

        Provider(
          create: (c) => BuildMushafPageUseCase(
            c.read<LayoutUseCase>(),
            c.read<AyahWordUseCase>(),
            c.read<SurahNameUseCase>(),
            c.read<JuzUseCase>(),
          ),
        ),
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