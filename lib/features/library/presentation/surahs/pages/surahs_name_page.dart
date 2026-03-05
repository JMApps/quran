import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../domain/entities/surah_name_entity.dart';
import '../../../domain/usecases/surah_name_use_case.dart';
import '../lists/surahs_name_list.dart';

class SurahNamePage extends StatefulWidget {
  const SurahNamePage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<SurahNamePage> createState() => _SurahNamePageState();
}

class _SurahNamePageState extends State<SurahNamePage> {
  late final SurahNameUseCase _surahsUseCase;
  late final Future<List<SurahNameEntity>> _futureSurahs;

  @override
  void initState() {
    super.initState();
    _surahsUseCase = context.read<SurahNameUseCase>();
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
      body: FutureBuilder<List<SurahNameEntity>>(
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

          final surahs = snapshot.data ?? const <SurahNameEntity>[];
          return SurahsNameList(
            scrollController: widget.scrollController,
            surahsList: surahs,
          );
        },
      ),
    );
  }
}
