import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../items/word_glyph_item.dart';

class WordGlyphList extends StatefulWidget {
  const WordGlyphList({
    super.key,
    required this.layoutsPage,
  });

  final List<LayoutEntity> layoutsPage;

  @override
  State<WordGlyphList> createState() => _WordGlyphListState();
}

class _WordGlyphListState extends State<WordGlyphList> {
  late final ItemScrollController _itemScrollController;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_itemScrollController.isAttached) {
        _itemScrollController.jumpTo(
          index: 0,
          alignment: 0.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      padding: AppStyles.hrMiniVrBigPadding,
      itemCount: widget.layoutsPage.length,
        itemBuilder: (context, index) {
          final layoutModel = widget.layoutsPage[index];

          if (index == 0) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

                return SizedBox(
                  height: screenHeight,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.layoutsPage.map((layout) => WordGlyphItem(
                          layoutModel: layout,
                          index: widget.layoutsPage.indexOf(layout),
                        )).toList(),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (index != 0) return const SizedBox.shrink();

          return WordGlyphItem(
            layoutModel: layoutModel,
            index: index,
          );
        },
    );
  }
}