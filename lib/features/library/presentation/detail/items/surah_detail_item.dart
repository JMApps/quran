import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/surah_state.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(context.read<SurahState>().getSurahByPage(pageNumber)!.nameArabic),
          Text(pageNumber.toString()),
        ],
      ),
    );
  }
}
