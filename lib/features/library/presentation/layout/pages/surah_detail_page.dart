import 'package:flutter/material.dart';

class SurahDetailPage extends StatefulWidget {
  final int pageNumber;

  const SurahDetailPage({
    super.key,
    required this.pageNumber,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageNumber.toString()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.language_rounded),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
