import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../domain/entities/juz_entity.dart';
import '../../state/surah_state.dart';
import '../widgets/juz_verse_key_row.dart';

class JuzItem extends StatelessWidget {
  const JuzItem({
    super.key,
    required this.juzModel,
    required this.index,
  });

  final JuzEntity juzModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(15);
    final itemEvenColor = appColors.secondary.withAlpha(0);
    return ListTile(
      visualDensity: VisualDensity.comfortable,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.primaryContainer,
      focusColor: appColors.primary.withAlpha(55),
      leading: CircleAvatar(
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            juzModel.juzNumber.toString(),
            style: TextStyle(
              color: appColors.secondary,
              fontSize: 15.0,
              fontWeight: .bold,
            ),
          ),
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: .center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .stretch,
              children: [
                JuzVerseKeyRow(
                  title: AppStrings.start,
                  color: appColors.secondaryContainer.withAlpha(105),
                  verseKey: juzModel.firstVerseKey,
                ),
                const SizedBox(height: 3.5),
                JuzVerseKeyRow(
                  title: AppStrings.end,
                  color: appColors.tertiaryContainer.withAlpha(105),
                  verseKey: juzModel.lastVerseKey,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${juzModel.versesCount}\n${AppStrings.ayahWord(juzModel.versesCount)}',
              style: TextStyle(
                color: appColors.tertiary,
              ),
              textAlign: .center,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: .center,
        children: [
          const Text(AppStrings.pageShort),
          Text(
            juzModel.startPageNumber.toString(),
            style: TextStyle(
              color: appColors.secondary,
              fontSize: 13.0,
              fontWeight: .bold,
            ),
          ),
        ],
      ),
      onTap: () {
        final surahState = Provider.of<SurahState>(context, listen: false);
        surahState.mushafCurrentPage = juzModel.startPageNumber;
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
    );
  }
}
