import 'package:flutter/material.dart';

import '../../../../../core/database/layout_database_service.dart';
import '../../../../../core/database/surahs_database_service.dart';
import '../../../../../core/database/word_database_service.dart';
import '../../../data/repositories/layout_line_repository_impl.dart';
import '../../../data/repositories/surah_repository_impl.dart';
import '../../../data/repositories/word_repository_impl.dart';
import '../../../domain/usecases/get_page_word_use_case.dart';
import '../../../domain/usecases/layout_line_use_case.dart';
import '../../../domain/usecases/surah_use_case.dart';
import '../items/quran_page_item.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;
  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late final PageController _controller;
  late final LayoutLineUseCase _layoutLineUseCase;
  late final GetPageWordsUseCase _getPageWordsUseCase;
  late final SurahUseCase _surahUseCase;

  @override
  void initState() {
    super.initState();
    final initial = (widget.pageNumber.clamp(1, 604) - 1);
    _controller = PageController(initialPage: initial);
    _layoutLineUseCase = LayoutLineUseCase(LayoutLineRepositoryImpl(LayoutDatabaseService.instance));
    _getPageWordsUseCase = GetPageWordsUseCase(WordRepositoryImpl(WordDatabaseService.instance));
    _surahUseCase = SurahUseCase(SurahRepositoryImpl(SurahsDatabaseService.instance));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: PageView.builder(
          controller: _controller,
          itemCount: 604,
          itemBuilder: (context, index) {
            final pageNumber = index + 1;
            return QuranPageItem(
              pageNumber: pageNumber,
              layoutLineUseCase: _layoutLineUseCase,
              getPageWordsUseCase: _getPageWordsUseCase,
              surahUseCase: _surahUseCase,
            );
          },
        ),
      ),
    );
  }
}