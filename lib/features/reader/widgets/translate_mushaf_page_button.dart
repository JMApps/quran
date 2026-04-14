import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../library/presentation/state/page_meta_state.dart';

class TranslateMushafPageButton extends StatelessWidget {
  const TranslateMushafPageButton({
    super.key,
    required this.currentMushafPage,
  });

  final int currentMushafPage;

  @override
  Widget build(BuildContext context) {
    return Consumer<PageMetaState>(
      builder: (context, pageMetaState, _) {
        return IconButton(
          onPressed: () {
            pageMetaState.translationEnabled = !pageMetaState.translationEnabled;
          },
          visualDensity: const VisualDensity(horizontal: -4),
          tooltip: AppStrings.translate,
          icon: Icon(pageMetaState.translationEnabled ? Icons.menu_book_rounded : Icons.public_outlined),
        );
      },
    );
  }
}
