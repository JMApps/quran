import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../domain/entities/hizb_entity.dart';
import '../../state/surah_state.dart';

class HizbItem extends StatelessWidget {
  const HizbItem({
    super.key,
    required this.hizbModel,
    required this.index,
  });

  final HizbEntity hizbModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(15);
    final itemEvenColor = appColors.secondary.withAlpha(0);
    final surahState = context.read<SurahState>();

    final parts = hizbModel.firstVerseKey.split(':');
    final surahNumber = int.tryParse(parts[0]);
    final ayahNumber = int.tryParse(parts[1]);

    final surahName = surahState.getSurahById(surahNumber!);

    return ListTile(
      visualDensity: .comfortable,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.primaryContainer,
      focusColor: appColors.primary.withAlpha(55),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          hizbModel.hizbNumber.toString(),
        ),
      ),
      title: Row(
        children: [
          Text(
            '${AppStrings.surah} ${surahName!.nameTranscription}',
            style: const TextStyle(
              fontFamily: AppStrings.fontGilroyMedium,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 7),
          Text(
            '${AppStrings.ayah} $ayahNumber',
            style: const TextStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      subtitle: Text(
        '${hizbModel.versesCount} ${AppStrings.plural(hizbModel.versesCount, 'аят', 'аята', 'аятов')}',
        style: const TextStyle(fontSize: 12.0),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        hizbModel.startPageNumber.toString(),
      ),
      onTap: () {
        final surahState = Provider.of<SurahState>(context, listen: false);
        surahState.setMushafCurrentPage(hizbModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
    );
  }
}
