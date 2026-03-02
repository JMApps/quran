import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/theme/app_strings.dart';

import '../../state/surah_state.dart';
import '../lists/surah_detail_list.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.pageNumber, // 1..604
  });

  final int pageNumber;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late final PageController _controller;

  int _indexFromPageNumber(int pageNumber) => AppStrings.totalPages - pageNumber;

  @override
  void initState() {
    super.initState();

    // Открываем именно widget.pageNumber корректно для reverse:true
    final initialIndex = _indexFromPageNumber(widget.pageNumber);
    _controller = PageController(initialPage: initialIndex);

    // Синхронизируем state, чтобы AppBar показал правильную страницу сразу
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SurahState>().currentPageIndex = initialIndex;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageNumberTitle = context.select<SurahState, int>((s) => s.currentPageNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('Страница $pageNumberTitle'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.public_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SurahDetailList(mushafPageController: _controller),
      ),
    );
  }
}