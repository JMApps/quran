import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/surah_name_state.dart';
import 'favorite_page_button.dart';
import 'to_page_button.dart';
import 'translate_mushaf_page_button.dart';

class MushafPageAppBar extends StatelessWidget {
  const MushafPageAppBar({super.key,
    required this.currentPageNumber,
    required this.pageMetaModel,
    required this.surahNameModel,
    required this.translationController,
  });

  final int currentPageNumber;
  final PageMetaEntity pageMetaModel;
  final SurahNameEntity surahNameModel;
  final PageController translationController;

  @override
  Widget build(BuildContext context) {
    final showAppBar = context.select<SurahNameState, bool>((s) => s.showAppBar);
    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      offset: showAppBar ? Offset.zero : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showAppBar ? 1 : 0,
        child: IgnorePointer(
          ignoring: !showAppBar,
          child: AppBar(
            elevation: 3.5,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${AppStrings.surah} ${surahNameModel.nameTranscription}',
                  style: AppStyles.mainTextStyle18,
                ),
                Row(
                  children: [
                    Text(
                      '${AppStrings.page} $currentPageNumber, ',
                      style: AppStyles.mainTextStyle12,
                    ),
                    Text(
                      '${AppStrings.juz.toLowerCase()} ${pageMetaModel.juzNumber}',
                      style: AppStyles.mainTextStyle12,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              const FavoritePageButton(),
              TranslateMushafPageButton(currentMushafPage: currentPageNumber),
              ToPageButton(translationController: translationController),
            ],
          ),
        ),
      ),
    );
  }
}