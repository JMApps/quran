import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_styles.dart';
import '../../../domain/entities/mushaf_page_meta_entity.dart';
import '../../state/mushaf_page_meta_state.dart';
import '../../state/surah_state.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({super.key});

  @override
  Widget build(BuildContext context) {
    final int mushafPageIndex = context.select<SurahState, int>((s) => s.currentMushafPageIndex);
    final mushafPageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>((s) => s.getPageMetaByPageNumber(mushafPageIndex));
    return Center(
      child: Padding(
        padding: AppStyles.hrMiniPadding,
        child: Column(
          children: [
            Row(
              children: [
                Text('Сура ${mushafPageMeta?.nameTranscription}'),
                const Expanded(child: SizedBox()),
                Text('джуз ${mushafPageMeta?.juzNumber}'),
                Text(mushafPageMeta?.hizbNumber == null ? '' : ', хизб ${mushafPageMeta?.hizbNumber}')
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Страница мусхафа на арабском\n(на стадии разработки) ${mushafPageIndex + 1}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Text('${mushafPageIndex + 1}'),
          ],
        ),
      ),
    );
  }
}