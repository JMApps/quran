import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/hizb_state.dart';
import 'package:quran/features/library/presentation/state/juz_state.dart';

import '../../../domain/entities/hizb_entity.dart';
import '../../state/surah_state.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    final HizbEntity? hizb = context.read<HizbState>().getHizbByPage(pageNumber);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Сура ${context.read<SurahState>().getSurahByPage(pageNumber)!.nameTranscription}'),
                const Expanded(child: SizedBox()),
                Text('Джуз ${context.read<JuzState>().getJuzByPage(pageNumber)!.juzNumber}${hizb != null ? ',' : ''}'),
                Text(hizb != null ? ' Хизб ${hizb.hizbNumber}' : ''),
              ],
            ),
            const Expanded(child: SizedBox()),
            Text(pageNumber.toString()),
          ],
        ),
      ),
    );
  }
}
