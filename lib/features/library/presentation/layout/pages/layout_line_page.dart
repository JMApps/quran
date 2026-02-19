import 'package:flutter/material.dart';

class LayoutLinePage extends StatefulWidget {
  final int pageNumber;

  const LayoutLinePage({
    super.key,
    required this.pageNumber,
  });

  @override
  State<LayoutLinePage> createState() => _LayoutLinePageState();
}

class _LayoutLinePageState extends State<LayoutLinePage> {
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
