import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/translation_type.dart';

class TranslationDropDown extends StatelessWidget {
  const TranslationDropDown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TranslationType value;
  final Function(TranslationType) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(AppStrings.semanticTranslation),
      trailing: DropdownButton<TranslationType>(
        borderRadius: AppStyles.mainBorder,
        elevation: 1,
        padding: AppStyles.withoutRightPaddingMini,
        alignment: Alignment.center,
        value: value,
        items: List.generate(
          TranslationType.values.length,
              (index) {
            final type = TranslationType.values[index];
            return DropdownMenuItem<TranslationType>(
              value: type,
              child: Text(
                AppStrings.semanticTranslationNames[index],
                style: TextStyle(
                  fontWeight: value == type ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        underline: const SizedBox(),
        onChanged: (TranslationType? newValue) {
          if (newValue != null) onChanged(newValue);
        },
      ),
    );
  }
}