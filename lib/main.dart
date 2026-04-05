import 'package:flutter/cupertino.dart';
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

  await Future.wait([
    if (!Hive.isBoxOpen(AppKeys.mushafFavoriteSettingsBox))
      Hive.openBox(AppKeys.mushafFavoriteSettingsBox),
    if (!Hive.isBoxOpen(AppKeys.mainAppSettingsBox)) Hive.openBox(AppKeys.mainAppSettingsBox),
  ]);

  final databaseService = QuranDatabaseService.instance;

  runApp(
    MultiProvider(
      providers: AppProviders.build(databaseService),
      child: const RootPage(),
    ),
  );
}
