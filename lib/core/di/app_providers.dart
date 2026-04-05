import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/library/data/repositories/ayah_by_ayah_repository_impl.dart';
import '../../features/library/data/repositories/hizb_repository_impl.dart';
import '../../features/library/data/repositories/juz_repository_impl.dart';
import '../../features/library/data/repositories/layout_repository_impl.dart';
import '../../features/library/data/repositories/mushaf_page_meta_repository_impl.dart';
import '../../features/library/data/repositories/surah_name_repository_impl.dart';
import '../../features/library/domain/usecases/ayah_by_ayah_use_case.dart';
import '../../features/library/domain/usecases/hizb_use_case.dart';
import '../../features/library/domain/usecases/juz_use_case.dart';
import '../../features/library/domain/usecases/layout_use_case.dart';
import '../../features/library/domain/usecases/mushaf_page_meta_use_case.dart';
import '../../features/library/domain/usecases/surah_name_use_case.dart';
import '../../features/library/presentation/state/ayah_by_ayah_state.dart';
import '../../features/library/presentation/state/hizb_state.dart';
import '../../features/library/presentation/state/juz_state.dart';
import '../../features/library/presentation/state/main_state.dart';
import '../../features/library/presentation/state/mushaf_page_meta_state.dart';
import '../../features/library/presentation/state/page_layout_state.dart';
import '../../features/library/presentation/state/surah_state.dart';
import '../../features/settings/state/app_settings_state.dart';
import '../database/quran_database_service.dart';
import '../services/mushaf_font_loader.dart';

class AppProviders {
  static List<SingleChildWidget> build(QuranDatabaseService databaseService) {
    return [
      ..._coreProviders(),
      ..._repositoryProviders(databaseService),
      ..._useCaseProviders(),
      ..._stateProviders(),
    ];
  }

  static List<SingleChildWidget> _coreProviders() => [
    ChangeNotifierProvider<AppSettingsState>(
      create: (_) => AppSettingsState(),
    ),
    Provider<MushafFontLoader>(
      create: (_) => MushafFontLoader.instance,
    ),
    ChangeNotifierProvider<MainState>(
      create: (_) => MainState(),
    ),
  ];

  static List<SingleChildWidget> _repositoryProviders(QuranDatabaseService databaseService) => [
    Provider<AyahByAyahRepositoryImpl>(
      create: (_) => AyahByAyahRepositoryImpl(databaseService),
    ),
    Provider<JuzRepositoryImpl>(
      create: (_) => JuzRepositoryImpl(databaseService),
    ),
    Provider<HizbRepositoryImpl>(
      create: (_) => HizbRepositoryImpl(databaseService),
    ),
    Provider<LayoutRepositoryImpl>(
      create: (_) => LayoutRepositoryImpl(databaseService),
    ),
    Provider<SurahNameRepositoryImpl>(
      create: (_) => SurahNameRepositoryImpl(databaseService),
    ),
    Provider<MushafPageMetaRepositoryImpl>(
      create: (_) => MushafPageMetaRepositoryImpl(databaseService),
    ),
  ];

  static List<SingleChildWidget> _useCaseProviders() => [
    Provider<AyahByAyahUseCase>(
      create: (context) => AyahByAyahUseCase(
        context.read<AyahByAyahRepositoryImpl>(),
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
  ];

  static List<SingleChildWidget> _stateProviders() => [
    ChangeNotifierProvider<AyahByAyahState>(
      lazy: false,
      create: (context) => AyahByAyahState(
        context.read<AyahByAyahUseCase>(),
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
    ChangeNotifierProvider<PageLayoutState>(
      lazy: false,
      create: (context) => PageLayoutState(
        context.read<LayoutUseCase>(),
      ),
    ),
  ];
}