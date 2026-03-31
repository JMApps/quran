import 'package:flutter/material.dart';

import '../../../../../core/theme/app_styles.dart';

class HizbVerseKeyRow extends StatelessWidget {
  const HizbVerseKeyRow({
    super.key,
    required this.title,
    required this.firstColor,
    required this.lastColor,
    required this.verseKey,
  });

  final String title;
  final Color firstColor;
  final Color lastColor;
  final String verseKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: .end,
            overflow: .ellipsis,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          flex: 2,
          child: Container(
            padding: AppStyles.microPadding,
            alignment: .center,
            decoration: BoxDecoration(
              color: lastColor,
              borderRadius: AppStyles.miniBorder,
            ),
            child: Text(
              verseKey,
              overflow: .ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
