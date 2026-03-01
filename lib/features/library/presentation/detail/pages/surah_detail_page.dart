import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/surah_state.dart';
import '../lists/surah_detail_list.dart';

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
  late final PageController _surahDetailPageController;

  @override
  void initState() {
    super.initState();

    final initialIndex = context.read<SurahState>().currentPageIndex; // или твой фикс
    _surahDetailPageController = PageController(initialPage: initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Selector<SurahState, int>(
          selector: (_, s) => s.currentPageNumber,
          builder: (_, pageNumber, _) => Text('Страница $pageNumber'),
        ),
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
      body: SurahDetailList(
        mushafPageController: _surahDetailPageController,
      ),
    );
  }
}
