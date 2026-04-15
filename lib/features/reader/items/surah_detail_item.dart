import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/strings/app_strings.dart';

import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../lists/ayah_by_ayah_list.dart';

class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
    required this.surahNameTranscription,
    required this.pageNumber,
    required this.juzNumber,
    required this.ayahPosition,
  });

  final int index;
  final String surahNameTranscription;
  final int pageNumber;
  final int juzNumber;
  final int ayahPosition;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> with AutomaticKeepAliveClientMixin {
  late final int _pageNumber;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageNumber = widget.index + 1;
    Provider.of<AyahByAyahState>(context, listen: false).loadPageAyahs(pageNumber: _pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final translationEnabled = context.select<PageMetaState, bool>((s) => s.translationEnabled);
    final isLoaded = context.select<AyahByAyahState, bool>(
      (s) => s.isPageLoaded(pageNumber: _pageNumber),
    );
    final error = context.select<AyahByAyahState, Object?>(
      (s) => s.getPageError(pageNumber: _pageNumber),
    );
    final ayahsPage = context.select<AyahByAyahState, List<AyahByAyahEntity>>(
      (s) => s.getPageAyahs(pageNumber: _pageNumber),
    );

    if (error != null) {
      return const Center(child: Icon(Icons.error_rounded));
    }

    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (translationEnabled) {
      return AyahByAyahList(
        ayahsPage: ayahsPage,
        ayahPosition: widget.ayahPosition,
      );
    }

    return Container(
      padding: AppStyles.mainPadding,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text('${AppStrings.surah} ${widget.surahNameTranscription}'),
              Text('${AppStrings.juz} ${widget.juzNumber}'),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Рендер страницы мусхафа на стадии разработки',
                style: AppStyles.mainTextStyle18,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Text(
            widget.pageNumber.toString(),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
