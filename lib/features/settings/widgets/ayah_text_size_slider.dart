import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';

class AyahTextSizeSlider extends StatelessWidget {
  const AyahTextSizeSlider({
    super.key,
    required this.title,
    required this.size,
    required this.onChanged,
  });

  final String title;
  final double size;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: .adaptivePlatformDensity,
      contentPadding: .zero,
      title: Padding(
        padding: AppStyles.hrMainPadding,
        child: Row(
          children: [
            Text(
              title,
              style: AppStyles.mediumTextStyle16,
            ),
            Expanded(
              child: Slider(
                showValueIndicator: .alwaysVisible,
                value: size,
                label: size.round().toString(),
                min: 14.0,
                max: 120.0,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
