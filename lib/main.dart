import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/database/quran_database_service.dart';
import 'core/di/app_providers.dart';
import 'core/strings/app_keys.dart';
import 'features/library/presentation/main/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await _openBoxWithRecovery(AppKeys.mainAppSettingsBox);
  await _openBoxWithRecovery(AppKeys.favoriteSettingsBox);

  final databaseService = QuranDatabaseService.instance;
  unawaited(databaseService.db);

  runApp(
    MultiProvider(
      providers: AppProviders.build(databaseService),
      child: const RootPage(),
    ),
  );
}

Future<void> _openBoxWithRecovery(String name) async {
  try {
    await Hive.openBox(name);
  } catch (_, _) {
    await Hive.deleteBoxFromDisk(name);
    await Hive.openBox(name);
  }
}
