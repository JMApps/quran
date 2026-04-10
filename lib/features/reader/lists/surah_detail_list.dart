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

class _SurahDetailListState extends State<SurahDetailList> with WidgetsBindingObserver {
  late final MushafPageMetaState _mushafPageMetaState;

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentPage = Provider.of<SurahState>(context, listen: false).currentMushafPage;

    // Предзагрузка шрифтов вокруг стартовой страницы
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MushafFontState>(context, listen: false).preloadRange(_currentPage - 2, _currentPage + 2);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mushafPageMetaState = Provider.of<MushafPageMetaState>(context, listen: false);
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
    final appSettingsState = Provider.of<AppSettingsState>(context, listen: false);
    final fontLoaderState = Provider.of<MushafFontState>(context, listen: false);
    final tableName = AppStrings.resolveTranslation(
      locale: Localizations.localeOf(context).languageCode,
      userSelected: appSettingsState.translationType == TranslationType.defaultTranslation ? null : appSettingsState.translationType).table;
    return PageView.builder(
      reverse: true,
      controller: widget.mushafPageController,
      itemCount: AppStrings.totalPages,
      onPageChanged: (int index) {
        _currentPage = index + 1;
        Provider.of<SurahState>(context, listen: false).setMushafCurrentPage(_currentPage);
        fontLoaderState.preloadRange(_currentPage - 1, _currentPage + 1);
        fontLoaderState.onPageChanged(_currentPage);
      },
      itemBuilder: (context, index) {
        return SurahDetailItem(
          index: index,
          ayahPosition: widget.ayahPosition,
          tableName: tableName,
        );
      },
    );
  }
}