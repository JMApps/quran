import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../items/setting_list_tile_item.dart';
import '../state/display_settings_state.dart';
import '../state/locale_settings_state.dart';
import '../state/reading_settings_state.dart';
import '../widgets/ayah_text_size_slider.dart';
import '../widgets/default_settings_button.dart';
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
        actions: const [
          DefaultSettingsButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const .only(bottom: kBottomNavigationBarHeight),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const Divider(indent: 14, endIndent: 14),
            Consumer<ReadingSettingsState>(
              builder: (BuildContext context, readingSettings, _) {
                return Column(
                  children: [
                    SettingListTileItem(
                      value: readingSettings.arabicNameSurah,
                      title: AppStrings.arabicSurahName,
                      onChanged: (bool onChanged) {
                        readingSettings.arabicNameSurah = onChanged;
                      },
                    ),
                    SettingListTileItem(
                      value: readingSettings.translationNameSurah,
                      title: AppStrings.translationSurahName,
                      onChanged: (bool onChanged) {
                        readingSettings.translationNameSurah = onChanged;
                      },
                    ),
                  ],
                );
              },
            ),
            const Divider(indent: 14, endIndent: 14),
            Consumer<DisplaySettingsState>(
              builder: (BuildContext context, displaySettings, _) {
                return Column(
                  children: [
                    SettingListTileItem(
                      value: displaySettings.displayAlwaysOn,
                      title: AppStrings.alwaysDisplayOn,
                      onChanged: (bool onChanged) {
                        displaySettings.setDisplayAlwaysOn(onChanged);
                      },
                    ),
                    const Divider(indent: 14, endIndent: 14),
                    ThemeModeDropDown(
                      value: displaySettings.appThemeModeIndex,
                      title: AppStrings.appTheme,
                      onChanged: (int? index) {
                        displaySettings.appThemeModeIndex = index!;
                      },
                    ),
                    const Divider(indent: 14, endIndent: 14),
                    ThemeColorPicker(
                      color: displaySettings.themeColor,
                      onChanged: (Color? color) {
                        Navigator.pop(context);
                        displaySettings.themeColor = color!;
                      },
                    ),
                    const Divider(indent: 14, endIndent: 14),
                  ],
                );
              },
            ),
            Consumer<LocaleSettingsState>(
              builder: (context, localeSettings, _) {
                return TranslationDropDown(
                  selectedIndex: localeSettings.translationNameIndex,
                  onChanged: (index) {
                    localeSettings.translationNameIndex = index;
                  },
                );
              },
            ),
            Consumer<ReadingSettingsState>(
              builder: (context, readingSettings, _) {
                return Column(
                  children: [
                    SettingListTileItem(
                      value: readingSettings.isArabicAyahShow,
                      title: AppStrings.arabicAyah,
                      onChanged: (onChanged) => readingSettings.isArabicAyahShow = onChanged,
                    ),
                    SettingListTileItem(
                      value: readingSettings.isTranslationAyahShow,
                      title: AppStrings.translationAyah,
                      onChanged: (onChanged) => readingSettings.isTranslationAyahShow = onChanged,
                    ),
                    const Divider(indent: 14, endIndent: 14),
                    const Padding(
                      padding: AppStyles.mainPadding,
                      child: Text(
                        AppStrings.ayahsTextSize,
                        style: AppStyles.mainTextStyle16,
                      ),
                    ),
                    AyahTextSizeSlider(
                      title: AppStrings.arabic,
                      size: readingSettings.ayahArabicTextSize,
                      onChanged: (double value) => readingSettings.ayahArabicTextSize = value,
                    ),
                    AyahTextSizeSlider(
                      title: AppStrings.translation,
                      size: readingSettings.ayahTranslationTextSize,
                      onChanged: (double value) => readingSettings.ayahTranslationTextSize = value,
                    ),
                  ],
                );
              },
            ),
            const Divider(indent: 14, endIndent: 14),
          ],
        ),
      ),
    );
  }
}
