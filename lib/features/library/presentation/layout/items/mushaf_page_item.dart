import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/surah_state.dart';

class MushafPageItem extends StatelessWidget {
  const MushafPageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        Provider.of<SurahState>(context).currentPageNumber.toString(),
      ),
    );
  }
}
