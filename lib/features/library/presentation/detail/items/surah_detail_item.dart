import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/mushaf_reader_state.dart';
import '../../../domain/entities/surah_detail_vm.dart';
import '../widgets/mushaf_15_lines_from_vm.dart';

class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.pageNumber, // 1..604
  });

  final int pageNumber;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> {
  @override
  void initState() {
    super.initState();
    // Страховка: если страница построилась до onPageChanged (например initial)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MushafReaderState>().loadPage(widget.pageNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.select<MushafReaderState, SurahDetailPageVm?>(
          (s) => s.getPageFromCache(widget.pageNumber),
    );

    final isLoading = context.select<MushafReaderState, bool>((s) {
      // показываем лоадинг если именно эта страница текущая для загрузчика и еще не в кэше
      return s.loading && s.currentPage == widget.pageNumber && s.getPageFromCache(widget.pageNumber) == null;
    });

    final error = context.select<MushafReaderState, Object?>((s) {
      return (s.currentPage == widget.pageNumber) ? s.error : null;
    });

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Ошибка загрузки страницы ${widget.pageNumber}: $error',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (vm == null) {
      // Пока пусто — лучше показать пустой экран, чем дергать лишнее.
      return const SizedBox.shrink();
    }

    return Mushaf15LinesFromVm(vm: vm);
  }
}