import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';

class TranslationDropDown extends StatelessWidget {
  const TranslationDropDown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(AppStrings.semanticTranslation),
      trailing: DropdownButton<String>(
        borderRadius: AppStyles.mainBorder,
        elevation: 1,
        padding: AppStyles.withoutRightPaddingMini,
        alignment: Alignment.center,
        value: value,
        items: List.generate(
          AppStrings.ayahTranslations.length,
              (index) {
            final translation = AppStrings.ayahTranslations[index];
            return DropdownMenuItem<String>(
              value: translation.name,
              child: Text(
                translation.name,
                style: TextStyle(
                  fontWeight: value == translation.name
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        underline: const SizedBox(),
        onChanged: (String? newValue) {
          if (newValue == null) return;
          final index = AppStrings.ayahTranslations.indexWhere((t) => t.name == newValue);
          if (index != -1) onChanged(index);
        },
      ),
    );
  }
}