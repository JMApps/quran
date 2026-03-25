import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/theme/app_strings.dart';

import '../../../../../core/theme/app_styles.dart';
import '../../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../../library/presentation/state/surah_state.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({super.key});

  @override
  Widget build(BuildContext context) {
    final int mushafPage = context.select<SurahState, int>((s) => s.currentMushafPage);
    final mushafPageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>((s) => s.getPageMetaByPage(mushafPage));
    return Center(
      child: Padding(
        padding: AppStyles.hrMiniPadding,
        child: Column(
          children: [
            Row(
              children: [
                Text('${AppStrings.surah} ${mushafPageMeta?.nameTranscription}'),
                const Expanded(child: SizedBox()),
                Text('${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber}'),
                Text(mushafPageMeta?.hizbNumber == null ? '' : ', ${AppStrings.hizb.toLowerCase()} ${mushafPageMeta?.hizbNumber}')
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Страница мусхафа на арабском\n(на стадии разработки) $mushafPage',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Text('$mushafPage'),
          ],
        ),
      ),
    );
  }
}