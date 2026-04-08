import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../library/data/arguments/surah_detail_args.dart';
import '../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../library/presentation/state/surah_state.dart';

class LastFavoritePageItem extends StatelessWidget {
  const LastFavoritePageItem({
    super.key,
    required this.mushafPageMetaModel,
    required this.index,
  });

  final MushafPageMetaEntity mushafPageMetaModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);
    return ListTile(
      visualDensity: .adaptivePlatformDensity,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.inversePrimary,
      focusColor: appColors.inversePrimary.withAlpha(55),
      leading: IconButton(
        onPressed: null,
        padding: .zero,
        visualDensity: .compact,
        color: appColors.secondary,
        icon: Icon(
          Icons.access_time_filled_rounded,
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        final surahState = Provider.of<SurahState>(context, listen: false);
        final arguments = SurahDetailArgs(
          currentMushafPage: mushafPageMetaModel.pageNumber,
        );
        surahState.setMushafCurrentPage(mushafPageMetaModel.pageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: arguments,
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
