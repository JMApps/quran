import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

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
      visualDensity: VisualDensity.comfortable,
      contentPadding: AppStyles.hrMainPadding,
      title: const Text(
        'Цвет темы',
      ),
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              alignment: Alignment.center,
              actionsPadding: AppStyles.mainPadding,
              title: const Text('Выберите цвет темы'),
              content: Material(
                color: Colors.transparent,
                child: MaterialColorPicker(
                  alignment: WrapAlignment.center,
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
