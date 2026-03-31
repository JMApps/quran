import 'package:flutter/material.dart';

import '../../../../../core/theme/app_styles.dart';

class JuzVerseKeyRow extends StatelessWidget {
  const JuzVerseKeyRow({
    super.key,
    required this.title,
    required this.color,
    required this.verseKey,
  });

  final String title;
  final Color color;
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
              color: color,
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
