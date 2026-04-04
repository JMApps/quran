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
    final bottomHeight = kBottomNavigationBarHeight + 20;
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        controller: scrollController,
        itemCount: juzsList.length,
        primary: false,
        padding: .only(bottom: bottomHeight),
        separatorBuilder: (context, index) => const Divider(height: 0.75),
        itemBuilder: (context, index) {
          final JuzEntity juzModel = juzsList[index];
          return JuzItem(
            juzModel: juzModel,
            index: index,
          );
        },
      ),
    );
  }
}
