import 'package:flutter/material.dart';
import 'package:quran/core/strings/app_strings.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../../domain/entities/hizb_entity.dart';
import '../items/hizb_item.dart';

class HizbsList extends StatelessWidget {
  const HizbsList({
    super.key,
    required this.hizbsList,
  });

  final List<HizbEntity> hizbsList;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: AppStyles.mainPadding,
          margin: AppStyles.miniPadding,
          alignment: .center,
          decoration: BoxDecoration(
            color: appColors.tertiaryContainer,
            borderRadius: AppStyles.miniBorder,
          ),
          child: const Text(
            AppStrings.hizbs,
            style: TextStyle(
              fontSize: 18.0,
            ),
            textAlign: .center,
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.separated(
              itemCount: hizbsList.length,
              padding: .zero,
              primary: false,
              separatorBuilder: (context, index) => const Divider(height: 0.75),
              itemBuilder: (context, index) {
                final HizbEntity hizbModel = hizbsList[index];
                return HizbItem(
                  hizbModel: hizbModel,
                  index: index,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
