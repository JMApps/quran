import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';

class TranslateMushafPageButton extends StatelessWidget {
  const TranslateMushafPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      visualDensity: const VisualDensity(horizontal: -4),
      tooltip: AppStrings.translate,
      icon: const Icon(Icons.public_outlined),
    );
  }
}
