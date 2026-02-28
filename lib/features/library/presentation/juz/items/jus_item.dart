import 'package:flutter/material.dart';

import '../../../domain/entities/juz_entity.dart';

class JuzItem extends StatelessWidget {
  const JuzItem({
    super.key,
    required this.juzModel,
    required this.index,
  });

  final JuzEntity juzModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        'Джуз – ${juzModel.juzNumber}',
      ),
      subtitle: Text(
        'Начало: ${juzModel.firstVerseKey} / Конец: ${juzModel.lastVerseKey}'
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          juzModel.juzNumber.toString(),
          style: TextStyle(
            fontSize: 16.0,
            color: appColors.primary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      trailing: Text(
        juzModel.startPageNumber.toString(),
        style: TextStyle(
          fontSize: 14.0,
          color: appColors.secondary,
        ),
      ),
    );
  }
}
