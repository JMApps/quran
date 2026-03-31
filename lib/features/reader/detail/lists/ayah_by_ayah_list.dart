import 'package:flutter/material.dart';

import '../../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../items/ayah_by_ayah_item.dart';

class AyahByAyahList extends StatelessWidget {
  const AyahByAyahList({
    super.key,
    required this.ayahsPage,
  });

  final List<AyahByAyahEntity> ayahsPage;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: ayahsPage.length,
      padding: const EdgeInsets.only(top: kToolbarHeight, bottom: 8),
      itemBuilder: (context, index) {
        final ayahByAyahModel = ayahsPage[index];
        return AyahByAyahItem(
          ayahByAyahModel: ayahByAyahModel,
          index: index,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
