import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../items/setting_list_tile_item.dart';
import '../state/app_settings_state.dart';
import '../widgets/ayah_text_size_slider.dart';
import '../widgets/theme_color_picker.dart';
import '../widgets/theme_mode_drop_down.dart';
import '../widgets/translation_drop_down.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: SingleChildScrollView(
        child: Consumer<AppSettingsState>(
          builder: (context, appSettingsState, _) {
            return Column(
              crossAxisAlignment: .stretch,
              children: [
                const Divider(indent: 16, endIndent: 16),
                SettingListTileItem(
                  value: appSettingsState.arabicNameSurah,
                  title: AppStrings.arabicSurahName,
                  onChanged: (bool onChanged) {
                    appSettingsState.arabicNameSurah = onChanged;
                  },
                ),
                SettingListTileItem(
                  value: appSettingsState.translationNameSurah,
                  title: AppStrings.translationSurahName,
                  onChanged: (bool onChanged) {
                    appSettingsState.translationNameSurah = onChanged;
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                SettingListTileItem(
                  value: appSettingsState.displayAlwaysOn,
                  title: AppStrings.alwaysDisplayOn,
                  onChanged: (bool onChanged) {
                    appSettingsState.setDisplayAlwaysOn(onChanged);
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                ThemeModeDropDown(
                  value: appSettingsState.appThemeModeIndex,
                  title: AppStrings.appTheme,
                  onChanged: (int? index) {
                    appSettingsState.appThemeModeIndex = index!;
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                ThemeColorPicker(
                  color: appSettingsState.themeColor,
                  onChanged: (Color? color) {
                    Navigator.pop(context);
                    appSettingsState.themeColor = color!;
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                TranslationDropDown(
                  value: appSettingsState.translationType,
                  onChanged: (value) {
                    appSettingsState.translationType = value;
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                const Padding(
                  padding: AppStyles.mainPadding,
                  child: Text(
                    AppStrings.ayahsTextSize,
                    style: AppStyles.mainTextStyle16,
                  ),
                ),
                AyahTextSizeSlider(
                  title: AppStrings.arabic,
                  size: appSettingsState.ayahArabicTextSize,
                  onChanged: (double value) => appSettingsState.ayahArabicTextSize = value,
                ),
                AyahTextSizeSlider(
                  title: AppStrings.translation,
                  size: appSettingsState.ayahTranslationTextSize,
                  onChanged: (double value) => appSettingsState.ayahTranslationTextSize = value,
                ),
                const Divider(indent: 16, endIndent: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
