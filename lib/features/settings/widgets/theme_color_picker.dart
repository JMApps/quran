import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../state/app_settings_state.dart';

class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
  });

  final Color color;
  final ValueChanged<ColorSwatch?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: .comfortable,
      contentPadding: AppStyles.hrMainPadding,
      title: const Text(
        AppStrings.themeColor,
      ),
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              alignment: Alignment.center,
              actionsPadding: AppStyles.mainPadding,
              title: const Text(AppStrings.selectThemeColor),
              content: Material(
                color: Colors.transparent,
                child: MaterialColorPicker(
                  alignment: .center,
                  iconSelected: Icons.check_circle,
                  elevation: 0.5,
                  allowShades: false,
                  onMainColorChange: onChanged,
                  selectedColor: Provider.of<AppSettingsState>(context).themeColor,
                ),
              ),
            ),
          );
        },
        icon: Icon(
          Icons.circle,
          color: color,
          size: 35,
        ),
      ),
    );
  }
}
