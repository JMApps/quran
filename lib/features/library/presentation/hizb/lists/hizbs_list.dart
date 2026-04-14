import 'package:flutter/material.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../domain/entities/hizb_entity.dart';
import '../items/hizb_item.dart';

class HizbsList extends StatefulWidget {
  const HizbsList({
    super.key,
    required this.hizbsList,
  });

  final List<HizbEntity> hizbsList;

  @override
  State<HizbsList> createState() => _HizbsListState();
}

class _HizbsListState extends State<HizbsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: AppStyles.mainPadding,
          margin: AppStyles.withoutTopPadding,
          alignment: .center,
          decoration: BoxDecoration(
            color: appColors.secondaryContainer,
            borderRadius: AppStyles.miniBorder,
          ),
          child: const Text(
            AppStrings.hizbs,
            style: AppStyles.mainTextStyle18,
            textAlign: .center,
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              primary: false,
              padding: .zero,
              itemCount: widget.hizbsList.length,
              itemBuilder: (context, index) {
                final HizbEntity hizbModel = widget.hizbsList[index];
                return HizbItem(
                  hizbModel: hizbModel,
                  index: index,
                );
              },
              separatorBuilder: (_, _) => const Divider(height: 0.75),
            ),
          ),
        ),
      ],
    );
  }
}
