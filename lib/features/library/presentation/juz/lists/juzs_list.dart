import 'package:flutter/material.dart';

import '../../../domain/entities/juz_entity.dart';
import '../items/juz_item.dart';
class JuzsList extends StatelessWidget {
  const JuzsList({
    super.key,
    required this.scrollController,
    required this.juzsList,
  });

  final ScrollController scrollController;
  final List<JuzEntity> juzsList;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 14;
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        primary: false,
        controller: scrollController,
        padding: .only(bottom: bottomHeight),
        itemCount: juzsList.length,
        itemBuilder: (context, index) {
          final JuzEntity juzModel = juzsList[index];
          return JuzItem(
            juzModel: juzModel,
            index: index,
          );
        },
        separatorBuilder: (_, _) => const Divider(height: 0.75),
      ),
    );
  }
}
