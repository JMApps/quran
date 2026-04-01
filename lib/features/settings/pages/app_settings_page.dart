import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../state/app_settings_state.dart';
import '../items/setting_list_tile_item.dart';
import '../widgets/theme_color_picker.dart';
import '../widgets/theme_mode_drop_down.dart';

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
                  title: 'Название сур на арабском',
                  onChanged: (bool onChanged) {
                    appSettingsState.arabicNameSurah = onChanged;
                  },
                ),
                SettingListTileItem(
                  value: appSettingsState.translationNameSurah,
                  title: 'Перевод названия сур',
                  onChanged: (bool onChanged) {
                    appSettingsState.translationNameSurah = onChanged;
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                SettingListTileItem(
                  value: appSettingsState.displayAlwaysOn,
                  title: 'Дисплей всегда включен',
                  onChanged: (bool onChanged) {
                    appSettingsState.setDisplayAlwaysOn(onChanged);
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                ThemeModeDropDown(
                  value: appSettingsState.appThemeModeIndex,
                  title: 'Тема приложения',
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
              ],
            );
          },
        ),
      ),
    );
  }
}
