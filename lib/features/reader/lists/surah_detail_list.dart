import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../library/domain/entities/translation_type.dart';
import '../../library/presentation/state/mushaf_font_state.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../library/presentation/state/surah_state.dart';
import '../../settings/state/app_settings_state.dart';
import '../items/surah_detail_item.dart';

class SurahDetailList extends StatefulWidget {
  const SurahDetailList({
    super.key,
    required this.mushafPageController,
    required this.ayahPosition,
  });

  final PageController mushafPageController;
  final int ayahPosition;

  @override
  State<SurahDetailList> createState() => _SurahDetailListState();
}

class _SurahDetailListState extends State<SurahDetailList>
    with WidgetsBindingObserver {
  late final MushafPageMetaState _mushafPageMetaState;

  int _currentPage = 1;

  /// Направление последнего листания (вперёд по тексту = true).
  /// PageView reverse: true → увеличение index = движение вперёд по Корану.
  bool _isDirectionForward = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentPage = Provider.of<SurahState>(context, listen: false).currentMushafPage;

    // При первом открытии ридера — параллельная preload-инициализация
    // шрифтов в диапазоне ±3 от стартовой страницы.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MushafFontState>(context, listen: false).preloadRange(
        _currentPage - 3,
        _currentPage + 3,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mushafPageMetaState =
        Provider.of<MushafPageMetaState>(context, listen: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _mushafPageMetaState.addLastOpenedPage(_currentPage);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appSettingsState =
    Provider.of<AppSettingsState>(context, listen: false);

    final tableName = AppStrings.resolveTranslation(
      locale: Localizations.localeOf(context).languageCode,
      userSelected: appSettingsState.translationType ==
          TranslationType.defaultTranslation
          ? null
          : appSettingsState.translationType,
    ).table;

    return PageView.builder(
      reverse: true,
      controller: widget.mushafPageController,
      itemCount: AppStrings.totalPages,
      onPageChanged: (int index) {
        final newPage = index + 1;

        // Определяем направление: в reverse PageView увеличение index
        // означает движение вперёд по тексту (следующая страница Корана).
        _isDirectionForward = newPage > _currentPage;
        _currentPage = newPage;

        Provider.of<SurahState>(context, listen: false)
            .setMushafCurrentPage(_currentPage);
      },
      itemBuilder: (context, index) {
        return SurahDetailItem(
          index: index,
          ayahPosition: widget.ayahPosition,
          tableName: tableName,
          isDirectionForward: _isDirectionForward,
        );
      },
    );
  }
}