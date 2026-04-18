import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quran/features/library/presentation/state/selected_ayah_state.dart';

import '../../features/library/data/repositories/ayah_by_ayah_repository_impl.dart';
import '../../features/library/data/repositories/hizb_repository_impl.dart';
import '../../features/library/data/repositories/juz_repository_impl.dart';
import '../../features/library/data/repositories/page_meta_repository_impl.dart';
import '../../features/library/data/repositories/surah_name_repository_impl.dart';
import '../../features/library/data/repositories/word_glyph_repository_impl.dart';
import '../../features/library/presentation/state/ayah_by_ayah_state.dart';
import '../../features/library/presentation/state/ayah_meta_state.dart';
import '../../features/library/presentation/state/favorites_state.dart';
import '../../features/library/presentation/state/hizb_state.dart';
import '../../features/library/presentation/state/juz_state.dart';
import '../../features/library/presentation/state/main_state.dart';
import '../../features/library/presentation/state/page_meta_state.dart';
import '../../features/library/presentation/state/surah_name_state.dart';
import '../../features/library/presentation/state/word_glyph_state.dart';
import '../../features/settings/state/app_settings_state.dart';
import '../database/quran_database_service.dart';

class AppProviders {
  static List<SingleChildWidget> build(QuranDatabaseService databaseService) {
    return [
      ..._coreProviders(),
      ..._repositoryProviders(databaseService),
      ..._stateProviders(),
    ];
  }

  static List<SingleChildWidget> _coreProviders() => [
    ChangeNotifierProvider<MainState>(
      create: (_) => MainState(),
    ),
    ChangeNotifierProvider<AppSettingsState>(
      create: (_) => AppSettingsState(),
    ),
    ChangeNotifierProvider<SelectedAyahState>(
      create: (_) => SelectedAyahState(),
    ),
  ];

  static List<SingleChildWidget> _repositoryProviders(QuranDatabaseService databaseService) => [
    Provider<WordGlyphRepositoryImpl>(
      create: (_) => WordGlyphRepositoryImpl(databaseService),
    ),
    Provider<SurahNameRepositoryImpl>(
      create: (_) => SurahNameRepositoryImpl(databaseService),
    ),
    Provider<AyahByAyahRepositoryImpl>(
      create: (_) => AyahByAyahRepositoryImpl(databaseService),
    ),
    Provider<JuzRepositoryImpl>(
      create: (_) => JuzRepositoryImpl(databaseService),
    ),
    Provider<HizbRepositoryImpl>(
      create: (_) => HizbRepositoryImpl(databaseService),
    ),
    Provider<PageMetaRepositoryImpl>(
      create: (_) => PageMetaRepositoryImpl(databaseService),
    ),
  ];

  static List<SingleChildWidget> _stateProviders() => [
    ChangeNotifierProvider<WordGlyphState>(
      lazy: false,
      create: (context) => WordGlyphState(
        context.read<WordGlyphRepositoryImpl>(),
      ),
    ),
    ChangeNotifierProvider<SurahNameState>(
      lazy: false,
      create: (context) => SurahNameState(
        context.read<SurahNameRepositoryImpl>(),
        context.read<AppSettingsState>(),
      )..loadAllSurahNames(),
    ),
    ChangeNotifierProvider<AyahByAyahState>(
      create: (context) => AyahByAyahState(
        context.read<AyahByAyahRepositoryImpl>(),
          context.read<AppSettingsState>(),
      ),
    ),
    ChangeNotifierProvider<JuzState>(
      lazy: false,
      create: (context) => JuzState(
        context.read<JuzRepositoryImpl>(),
      )..loadAllJuzs(),
    ),
    ChangeNotifierProvider<HizbState>(
      lazy: false,
      create: (context) => HizbState(
        context.read<HizbRepositoryImpl>(),
      )..loadAllHizbs(),
    ),
    ChangeNotifierProvider<AyahMetaState>(
      create: (context) => AyahMetaState(
        context.read<AyahByAyahRepositoryImpl>(),
        context.read<AppSettingsState>(),
      ),
    ),
    ChangeNotifierProvider<PageMetaState>(
      lazy: false,
      create: (context) => PageMetaState(
        context.read<PageMetaRepositoryImpl>(),
      )..loadAllPagesMeta(),
    ),
    ChangeNotifierProvider<FavoritesState>(
      create: (context) => FavoritesState(),
    ),
  ];
}
