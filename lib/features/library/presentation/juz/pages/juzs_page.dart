import 'package:flutter/material.dart';

import '../../../../../core/database/quran_database_service.dart';
import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../data/repositories/juz_repository_impl.dart';
import '../../../domain/entities/juz_entity.dart';
import '../../../domain/usecases/juz_use_case.dart';
import '../lists/juzs_list.dart';

class JuzsPage extends StatefulWidget {
  const JuzsPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<JuzsPage> createState() => _JuzsPageState();
}

class _JuzsPageState extends State<JuzsPage> {
  late final JuzUseCase _juzUseCase;
  late final Future<List<JuzEntity>> _futureJuzs;

  @override
  void initState() {
    super.initState();
    _juzUseCase = JuzUseCase(JuzRepositoryImpl(QuranDatabaseService.instance));
    _futureJuzs = _juzUseCase.getAllJuzs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.juzs),
      ),
      body: FutureBuilder<List<JuzEntity>>(
        future: _futureJuzs,
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
                  '${AppStrings.errorLoadJuzsList}\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final juzs = snapshot.data ?? const <JuzEntity>[];
          return JuzsList(
            scrollController: widget.scrollController,
            juzsList: juzs,
          );
        },
      ),
    );
  }
}
