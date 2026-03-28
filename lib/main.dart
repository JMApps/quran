import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/strings/app_keys.dart';
import 'features/library/presentation/main/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);

  if (!Hive.isBoxOpen(AppKeys.mushafFavoriteSettingsBox)) {
    await Hive.openBox(AppKeys.mushafFavoriteSettingsBox);
  }

  if (!Hive.isBoxOpen(AppKeys.mainAppSettingsBox)) {
    await Hive.openBox(AppKeys.mainAppSettingsBox);
  }

  runApp(
    const RootPage(),
  );
}
