import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';

class ThemeModeDropDown extends StatelessWidget {
  const ThemeModeDropDown({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });

  final String title;
  final int value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.comfortable,
      title: Text(
        title,
      ),
      trailing: DropdownButton<int>(
        borderRadius: AppStyles.mainBorder,
        elevation: 1,
        padding: AppStyles.withoutRightPaddingMini,
        alignment: Alignment.center,
        value: value,
        items: List.generate(
          3,
          (index) => DropdownMenuItem<int>(
            value: index,
            child: Text(
              AppStrings.appThemeModeNames[index],
              style: TextStyle(
                fontWeight: value == index ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }
}
