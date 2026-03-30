import 'package:flutter/material.dart';

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
    return Scrollbar(
      child: ListView.separated(
        itemCount: hizbsList.length,
        padding: EdgeInsets.zero,
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
