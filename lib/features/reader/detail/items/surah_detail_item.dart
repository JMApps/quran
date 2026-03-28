import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../../library/presentation/state/mushaf_page_meta_state.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final mushafPageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>(
      (s) => s.getPageMetaByPage(index + 1),
    );
    return Container(
      padding: const EdgeInsets.only(left: 8, top: kToolbarHeight, right: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text('${AppStrings.surah} ${mushafPageMeta?.nameTranscription}'),
              const Expanded(child: SizedBox()),
              Text('${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber}'),
              Text(
                mushafPageMeta?.hizbNumber == null ? '' : ', ${AppStrings.hizb.toLowerCase()} ${mushafPageMeta?.hizbNumber}',
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                'Страница мусхафа на арабском\n(на стадии разработки) ${index + 1}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Text('${index + 1}'),
        ],
      ),
    );
  }
}
