import 'package:flutter/foundation.dart';

import '../../domain/entities/surah_name_entity.dart';
import '../../domain/usecases/surah_name_use_case.dart';

class SurahState extends ChangeNotifier {
  final SurahNameUseCase _surahNameUseCase;

  SurahState(this._surahNameUseCase);

  int _mushafPage = 1;
  bool _showAppBar = true;

  List<SurahNameEntity> _allSurahs = const [];
  final Map<int, SurahNameEntity> _surahMap = {};

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  int get currentMushafPage => _mushafPage;
  bool get showAppBar => _showAppBar;

  List<SurahNameEntity> get allSurahs => List.unmodifiable(_allSurahs);

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  bool get hasError => _error != null;
  bool get hasData => _allSurahs.isNotEmpty;

  Object? get error => _error;

  SurahNameEntity? getSurahById(int surahNumber) {
    return _surahMap[surahNumber];
  }

  String? getSurahNameWithAyah({required String surah, required String ayah, required String verseKey}) {
    if (verseKey.trim().isEmpty) return null;

    final List<String> parts = verseKey.split(':');
    if (parts.length != 2) return null;

    final int? surahNumber = int.tryParse(parts[0]);
    final int? ayahNumber = int.tryParse(parts[1]);

    if (surahNumber == null || ayahNumber == null) {
      return null;
    }

    final SurahNameEntity? surahEntity = _surahMap[surahNumber];
    if (surahEntity == null) {
      return null;
    }

    return '$surah ${surahEntity.nameTranscription}, $ayah $ayahNumber';
  }

  void setMushafCurrentPage(int page) {
    if (_mushafPage == page) return;
    _mushafPage = page;
    notifyListeners();
  }

  void toggleShowAppBar() {
    _showAppBar = !_showAppBar;
    notifyListeners();
  }

  Future<void> loadAllSurahs() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<SurahNameEntity> surahs =
      await _surahNameUseCase.getAllSurahs();

      _allSurahs = surahs;
      _surahMap..clear()..addEntries(surahs.map((surah) => MapEntry(surah.surahNumber, surah)));

      _isLoaded = true;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAllSurahs() async {
    _isLoaded = false;
    _error = null;
    _surahMap.clear();
    _allSurahs = const [];
    await loadAllSurahs();
  }
}