import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';

class TranslationDropDown extends StatelessWidget {
  const TranslationDropDown({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(AppStrings.semanticTranslation),
      trailing: DropdownButton<int>(
        borderRadius: AppStyles.mainBorder,
        elevation: 1,
        padding: AppStyles.withoutRightPaddingMini,
        alignment: Alignment.center,
        value: selectedIndex,
        items: List.generate(
          AppStrings.ayahTranslations.length,
              (index) => DropdownMenuItem<int>(
            value: index,
            child: Text(
              AppStrings.ayahTranslations[index].name,
              style: TextStyle(
                fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        underline: const SizedBox(),
        onChanged: (int? newIndex) {
          if (newIndex != null) onChanged(newIndex);
        },
      ),
    );
  }
}