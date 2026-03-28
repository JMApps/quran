import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../state/app_settings_state.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
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
                SwitchListTile(
                  visualDensity: .comfortable,
                  contentPadding: AppStyles.hrMainPadding,
                  value: appSettingsState.arabicNameSurah,
                  onChanged: (bool onChanged) {
                    appSettingsState.arabicNameSurah = onChanged;
                  },
                  title: const Text('Название сур на арабском'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
