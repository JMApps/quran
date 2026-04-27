import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../state/translation_mode_state.dart';

class TranslateMushafPageButton extends StatelessWidget {
  const TranslateMushafPageButton({
    super.key,
    required this.currentMushafPage,
  });

  final int currentMushafPage;

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationModeState>(
      builder: (context, translationModeState, _) {
        return IconButton(
          onPressed: () {
            translationModeState.changeTranslationMode();
          },
          visualDensity: const VisualDensity(horizontal: -4),
          tooltip: AppStrings.translate,
          icon: Icon(
            translationModeState.translationMode ? Icons.menu_book_rounded : Icons.public_outlined,
          ),
        );
      },
    );
  }
}
