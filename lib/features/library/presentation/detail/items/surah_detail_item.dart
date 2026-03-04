import 'package:flutter/material.dart';

class SurahDetailItem extends StatelessWidget {
  const SurahDetailItem({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$pageNumber'),
    );
  }
}
