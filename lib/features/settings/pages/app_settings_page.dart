import 'package:flutter/material.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../../core/theme/app_strings.dart';

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
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            SwitchListTile(
              visualDensity: VisualDensity.comfortable,
              contentPadding: AppStyles.hrMainPadding,
              value: true,
              onChanged: (bool onChanged) {},
              title: const Text('Название сур на арабском'),
            ),
          ],
        ),
      ),
    );
  }
}
