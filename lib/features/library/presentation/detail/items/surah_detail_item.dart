import 'package:flutter/material.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        (pageIndex + 1).toString(),
      ),
    );
  }
}
