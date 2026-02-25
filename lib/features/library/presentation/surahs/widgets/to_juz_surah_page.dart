import 'package:flutter/material.dart';

class ToJuzSurahPage extends StatelessWidget {
  const ToJuzSurahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            visualDensity: VisualDensity.compact,
            title: const Text('Перейти к джузу'),
            trailing: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
          const Divider(endIndent: 16),
          ListTile(
            visualDensity: VisualDensity.compact,
            title: const Text('Перейти к суре'),
            trailing: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
          const Divider(endIndent: 16),
          ListTile(
            visualDensity: VisualDensity.compact,
            title: const Text('Перейти к странице'),
            trailing: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
