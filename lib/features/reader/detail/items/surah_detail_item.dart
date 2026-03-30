import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../../library/domain/entities/layout_entity.dart';
import '../../../library/domain/entities/line_type.dart';
import '../../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../../library/presentation/state/page_layout_state.dart';
import '../lists/ayah_by_ayah_list.dart';

class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> {
  late final int _pageNumber;

  @override
  void initState() {
    super.initState();
    _pageNumber = widget.index + 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PageLayoutState>().loadPageLines(_pageNumber);
      context.read<AyahByAyahState>().loadPageAyahs(_pageNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mushafPageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>(
          (s) => s.getPageMetaByPage(_pageNumber),
    );

    final translationState = context.select<MushafPageMetaState, bool>(
          (s) => s.translationState,
    );

    final lines = context.select<PageLayoutState, List<LayoutEntity>>(
          (s) => s.getPageLines(_pageNumber),
    );
    final layoutIsLoading = context.select<PageLayoutState, bool>(
          (s) => s.isLoading,
    );
    final layoutError = context.select<PageLayoutState, Object?>(
          (s) => s.error,
    );

    final ayahs = context.select<AyahByAyahState, List<AyahByAyahEntity>>(
          (s) => s.getPageAyahs(_pageNumber),
    );
    final ayahIsLoading = context.select<AyahByAyahState, bool>(
          (s) => s.isLoading,
    );
    final ayahError = context.select<AyahByAyahState, Object?>(
          (s) => s.error,
    );

    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        top: kToolbarHeight,
        right: 8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('${AppStrings.surah} ${mushafPageMeta?.nameTranscription ?? ''}'),
              const Expanded(child: SizedBox()),
              Text('${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber ?? ''}'),
              Text(
                mushafPageMeta?.hizbNumber == null
                    ? ''
                    : ', ${AppStrings.hizb.toLowerCase()} ${mushafPageMeta!.hizbNumber}',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: translationState
                ? _buildTranslationView(
              ayahs: ayahs,
              isLoading: ayahIsLoading,
              error: ayahError,
            )
                : _buildLayoutView(
              lines: lines,
              isLoading: layoutIsLoading,
              error: layoutError,
            ),
          ),
          Text('$_pageNumber'),
        ],
      ),
    );
  }

  Widget _buildTranslationView({
    required List<AyahByAyahEntity> ayahs,
    required bool isLoading,
    required Object? error,
  }) {
    if (error != null) {
      return Center(
        child: Text('Ошибка загрузки: $error'),
      );
    }

    if (isLoading && ayahs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (ayahs.isEmpty) {
      return const Center(
        child: Text('Нет аятов по странице'),
      );
    }

    return AyahByAyahList(ayahsPage: ayahs);
  }

  Widget _buildLayoutView({
    required List<LayoutEntity> lines,
    required bool isLoading,
    required Object? error,
  }) {
    if (error != null) {
      return Center(
        child: Text('Ошибка загрузки: $error'),
      );
    }

    if (isLoading && lines.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (lines.isEmpty) {
      return const Center(
        child: Text('Нет данных по странице'),
      );
    }

    return ListView.builder(
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];

        return Center(
          child: Padding(
            padding: AppStyles.mainPadding,
            child: Text(_lineTypeLabel(line.lineType)),
          ),
        );
      },
    );
  }

  String _lineTypeLabel(LineType type) {
    switch (type) {
      case LineType.surahName:
        return 'surah_name';
      case LineType.basmallah:
        return 'basmallah';
      case LineType.ayah:
        return 'ayah';
    }
  }
}