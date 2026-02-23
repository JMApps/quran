import 'package:flutter/material.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
