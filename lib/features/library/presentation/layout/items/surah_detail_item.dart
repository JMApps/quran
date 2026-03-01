import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/surah_state.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        Provider.of<SurahState>(context).currentPageNumber.toString(),
      ),
    );
  }
}
