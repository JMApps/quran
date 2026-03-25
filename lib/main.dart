import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_keys.dart';
import 'features/library/presentation/main/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  if (!Hive.isBoxOpen(AppKeys.mushafFavoriteSettingsBox)) {
    await Hive.openBox(AppKeys.mushafFavoriteSettingsBox);
  }

  runApp(
    const RootPage(),
  );
}
