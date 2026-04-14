import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/data/arguments/surah_detail_args.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../../settings/state/app_settings_state.dart';
import '../widgets/ayah_item_params.dart';

class FavoriteAyahItem extends StatefulWidget {
  const FavoriteAyahItem({
    super.key,
    required this.ayahByAyahModel,
    required this.index,
  });

  final AyahByAyahEntity ayahByAyahModel;
  final int index;

  @override
  State<FavoriteAyahItem> createState() => _FavoriteAyahItemState();
}

class _FavoriteAyahItemState extends State<FavoriteAyahItem> {
  final _key = GlobalKey();
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final surahState = Provider.of<SurahNameState>(context, listen: false);
    final String surahInfo = surahState.getSurahNameWithAyah(
      surah: AppStrings.surah,
      ayah: AppStrings.ayah,
      verseKey: widget.ayahByAyahModel.verseKey,
    );
    return InkWell(
      key: _key,
      onTap: () async {
        surahState.setCurrentPage(widget.ayahByAyahModel.ayahPageNumber);
        final arguments = SurahDetailArgs(
          currentMushafPage: widget.ayahByAyahModel.ayahPageNumber,
          ayahPosition: widget.ayahByAyahModel.ayahPosition - 1,
        );
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: arguments,
        );
      },
      onTapDown: (details) => _tapPosition = details.globalPosition,
      onLongPress: () {
        final box = _key.currentContext!.findRenderObject() as RenderBox;
        final widgetOffset = box.localToGlobal(Offset.zero);
        final widgetSize = box.size;

        const menuWidth = 160.0;
        const menuHeight = 56.0;

        final dx = (_tapPosition.dx + menuWidth > widgetOffset.dx + widgetSize.width ? widgetOffset.dx + widgetSize.width - menuWidth - 8 : _tapPosition.dx).clamp(widgetOffset.dx + 8, widgetOffset.dx + widgetSize.width - menuWidth - 8);
        final dy = (_tapPosition.dy + menuHeight > widgetOffset.dy + widgetSize.height ? widgetOffset.dy + widgetSize.height - menuHeight - 8 : _tapPosition.dy - menuHeight).clamp(widgetOffset.dy + 8, widgetOffset.dy + widgetSize.height - menuHeight - 8);

        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (_) => Stack(
            children: [
              Positioned(
                left: dx,
                top: dy,
                child: Material(
                  shape: AppStyles.miniShape,
                  color: appColors.primaryContainer,
                  elevation: 8,
                  child: AyahItemParams(
                    ayahByAyahModel: widget.ayahByAyahModel,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: AppStyles.mainPadding,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.25,
              color: Colors.grey,
            ),
          ),
        ),
        child: Consumer<AppSettingsState>(
          builder: (context, appSettingsState, _) {
            return Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  widget.ayahByAyahModel.ayahArabic,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: appSettingsState.ayahArabicTextSize,
                    fontFamily: AppStrings.fontUthmanicHafs,
                    height: 2.5,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.ayahByAyahModel.ayahTranslation,
                  style: TextStyle(
                    fontSize: appSettingsState.ayahTranslationTextSize,
                    fontFamily: AppStrings.fontGilroy,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  surahInfo,
                  style: AppStyles.mainTextStyle16.copyWith(
                    color: appColors.onSurface.withAlpha(105),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
