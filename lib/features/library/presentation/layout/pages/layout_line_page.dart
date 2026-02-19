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
        title: Text('Page ${widget.pageNumber}'),
      ),
      body: Container(),
    );
  }
}
