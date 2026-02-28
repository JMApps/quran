import 'package:flutter/material.dart';

import '../../../../../core/database/quran_database_service.dart';
import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../data/repositories/surah_repository_impl.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../../domain/usecases/surah_use_case.dart';
import '../lists/surah_list.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late final SurahUseCase _surahsUseCase;
  late final Future<List<SurahEntity>> _futureSurahs;

  @override
  void initState() {
    super.initState();
    final surahsRepository = SurahRepositoryImpl(QuranDatabaseService.instance);
    _surahsUseCase = SurahUseCase(surahsRepository);
    _futureSurahs = _surahsUseCase.getAllSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () {
              // Открыть showSearch(context: context, delegate: delegate)
            },
            tooltip: AppStrings.searchByAyahs,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: FutureBuilder<List<SurahEntity>>(
        future: _futureSurahs,
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
                  '${AppStrings.errorLoadSurahsList}\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final surahs = snapshot.data ?? const <SurahEntity>[];
          return SurahList(
            scrollController: widget.scrollController,
            surahsList: surahs,
          );
        },
      ),
    );
  }
}
