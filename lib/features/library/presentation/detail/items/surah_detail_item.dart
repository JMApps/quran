import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/mushaf_page_meta_entity.dart';
import '../../state/mushaf_page_meta_state.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    final mushafPageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>((s) => s.getPageMetaByPageNumber(pageNumber));
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Сура ${mushafPageMeta?.nameTranscription}'),
                const Expanded(child: SizedBox()),
                Text('Джуз ${mushafPageMeta?.juzNumber}'),
                Text(mushafPageMeta?.hizbNumber == null ? '' : ', Хизб ${mushafPageMeta?.hizbNumber}')
              ],
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Страница мусхафа на арабском\n(на стадии разработки)',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Text(pageNumber.toString()),
          ],
        ),
      ),
    );
  }
}