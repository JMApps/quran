import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/database/surahs_database_service.dart';
import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../data/repositories/surah_repository_impl.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../../domain/usecases/surah_use_case.dart';
import '../../state/surah_state.dart';
import '../lists/surah_list.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late final ScrollController _scrollController;
  late final SurahUseCase _surahsUseCase;
  late final Future<List<SurahEntity>> _futureSurahs;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      Provider.of<SurahState>(context, listen: false).updateFabVisibility(_scrollController.offset);
    });

    final surahsDatabase = SurahsDatabaseService.instance;
    final surahsRepository = SurahRepositoryImpl(surahsDatabase);

    _surahsUseCase = SurahUseCase(surahsRepository);
    _futureSurahs = _surahsUseCase.getAllSurahs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () {},
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
            scrollController: _scrollController,
            surahsList: surahs,
          );
        },
      ),
      floatingActionButton: Consumer<SurahState>(
        builder: (context, surahState, _) {
          return AnimatedScale(
            scale: surahState.showFab ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            ),
          );
        },
      ),
    );
  }
}
