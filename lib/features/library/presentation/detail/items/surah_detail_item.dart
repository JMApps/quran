import 'package:flutter/material.dart';

class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.pageNumber.toString()),
    );
  }
}
