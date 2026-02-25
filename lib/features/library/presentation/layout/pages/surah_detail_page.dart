import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/layout/lists/mushaf_pages_list.dart';

import '../../state/surah_state.dart';

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
  late final PageController _mushafPageController;

  @override
  void initState() {
    super.initState();

    _mushafPageController = PageController(
      initialPage: Provider.of<SurahState>(context, listen: false).currentPageNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Страница ${Provider.of<SurahState>(context).currentPageNumber}'),
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
      body: MushafPagesList(
        mushafPageController: _mushafPageController,
      ),
    );
  }
}
