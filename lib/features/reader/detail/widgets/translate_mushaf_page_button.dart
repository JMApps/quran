import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/mushaf_page_meta_state.dart';

import '../../../../core/strings/app_strings.dart';

class TranslateMushafPageButton extends StatelessWidget {
  const TranslateMushafPageButton({
    super.key,
    required this.currentMushafPage,
  });

  final int currentMushafPage;

  @override
  Widget build(BuildContext context) {
    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        return IconButton(
          onPressed: () {
            mushafPageMetaState.translationState = !mushafPageMetaState.translationState;
          },
          visualDensity: const VisualDensity(horizontal: -4),
          tooltip: AppStrings.translate,
          icon: Icon(mushafPageMetaState.translationState ? Icons.menu_book_rounded : Icons.public_outlined),
        );
      },
    );
  }
}
