import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../domain/entities/hizb_entity.dart';
import '../../../domain/usecases/hizb_use_case.dart';
import '../lists/hizbs_list.dart';

class HizbsPage extends StatefulWidget {
  const HizbsPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<HizbsPage> createState() => _HizbsPageState();
}

class _HizbsPageState extends State<HizbsPage> {
  late final HizbUseCase _hizbUseCase;
  late final Future<List<HizbEntity>> _futureHizbs;

  @override
  void initState() {
    super.initState();
    _hizbUseCase = context.read<HizbUseCase>();
    _futureHizbs = _hizbUseCase.getAllHizbs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.hizbs),
      ),
      body: FutureBuilder<List<HizbEntity>>(
        future: _futureHizbs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: AppStyles.mainPadding,
                child: Text(
                  '${AppStrings.errorLoadHizbsList}\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final hizbs = snapshot.data ?? const <HizbEntity>[];
          return HizbsList(
            scrollController: widget.scrollController,
            hizbsList: hizbs,
          );
        },
      ),
    );
  }
}
