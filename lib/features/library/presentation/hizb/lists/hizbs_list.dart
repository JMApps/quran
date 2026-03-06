import 'package:flutter/material.dart';

import '../../../domain/entities/hizb_entity.dart';
import '../items/hizb_item.dart';

class HizbsList extends StatelessWidget {
  const HizbsList({
    super.key,
    required this.scrollController,
    required this.hizbsList,
  });

  final ScrollController scrollController;
  final List<HizbEntity> hizbsList;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 20;
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        controller: scrollController,
        itemCount: hizbsList.length,
        padding: EdgeInsets.only(bottom: bottomHeight),
        separatorBuilder: (context, index) => const Divider(height: 0.75),
        itemBuilder: (context, index) {
          final HizbEntity hizbModel = hizbsList[index];
          return HizbItem(
            hizbModel: hizbModel,
            index: index,
          );
        },
      ),
    );
  }
}
