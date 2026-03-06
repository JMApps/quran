import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
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
  late final PageController _controller;

  int _indexFromPageNumber(int pageNumber) => AppStrings.totalPages - pageNumber;

  @override
  void initState() {
    super.initState();

    final initialIndex = _indexFromPageNumber(widget.pageNumber);
    _controller = PageController(initialPage: initialIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurahState>(context, listen: false).currentPageIndex = initialIndex;
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
      extendBody: true,
      extendBodyBehindAppBar: true,
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
        bottom: false,
        child: SurahDetailList(mushafPageController: _controller),
      ),
    );
  }
}
