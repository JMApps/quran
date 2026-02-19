import 'package:flutter/material.dart';

import '../../../../../core/database/surahs_database_service.dart';
import '../../../../../core/router/names_router.dart';
import '../../../data/repositories/surah_repository_impl.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../../domain/usecases/surah_use_case.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late final SurahUseCase _useCase;
  late final Future<List<SurahEntity>> _futureSurahs;

  @override
  void initState() {
    super.initState();

    final dbService = SurahsDatabaseService.instance;

    final repo = SurahRepositoryImpl(dbService);
    _useCase = SurahUseCase(repo);

    _futureSurahs = _useCase.getAllSurahs();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Коран')),
      body: FutureBuilder<List<SurahEntity>>(
        future: _futureSurahs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Ошибка загрузки сур:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final surahs = snapshot.data ?? const <SurahEntity>[];
          if (surahs.isEmpty) {
            return const Center(child: Text('Суры не найдены'));
          }

          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final s = surahs[index];
              return ListTile(
                horizontalTitleGap: 6,
                leading: Text(
                  s.id.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: appColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  '${s.nameTranscription} (${s.nameTranslation})',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text(
                  '${s.ayahsCount} аятов — ${s.revelationPlace}',
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NamesRouter.pageLayoutLine,
                    arguments: s.pageNumber,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
