import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../library/presentation/state/surah_state.dart';

class LastFavoriteMushafPageItem extends StatelessWidget {
  const LastFavoriteMushafPageItem({
    super.key,
    required this.mushafPageMetaModel,
    required this.index,
  });

  final MushafPageMetaEntity mushafPageMetaModel;
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
      leading: IconButton(
        onPressed: null,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        color: appColors.secondary,
        icon: Icon(
          Icons.access_time_filled_rounded,
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        final surahState = Provider.of<SurahState>(context, listen: false);
        surahState.mushafCurrentPage = mushafPageMetaModel.pageNumber;
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
      title: Text('${AppStrings.surah} ${mushafPageMetaModel.nameTranscription}'),
      subtitle: Text(
        '${AppStrings.pageShort} ${mushafPageMetaModel.pageNumber}, ${AppStrings.juz.toLowerCase()} ${mushafPageMetaModel.juzNumber}',
      ),
      trailing: Text(
        mushafPageMetaModel.pageNumber.toString(),
        style: TextStyle(
          color: appColors.secondary,
        ),
      ),
    );
  }
}
