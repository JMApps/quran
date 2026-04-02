import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/strings/app_keys.dart';
import 'features/library/presentation/main/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    _initHive(),
    _registerAllQcfFonts(),
  ]);

  runApp(
    const RootPage(),
  );
}

Future<void> _initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await Future.wait([
    if (!Hive.isBoxOpen(AppKeys.mushafFavoriteSettingsBox))
      Hive.openBox(AppKeys.mushafFavoriteSettingsBox),
    if (!Hive.isBoxOpen(AppKeys.mainAppSettingsBox))
      Hive.openBox(AppKeys.mainAppSettingsBox),
  ]);
}

Future<void> _registerAllQcfFonts() async {
  await Future.wait([
    for (int page = 1; page <= 604; page++) _registerFont(page),
  ]);
}

Future<void> _registerFont(int pageNumber) async {
  final String family = 'QCF_P${pageNumber.toString().padLeft(3, '0')}';
  final int fileNumber = 4000 + pageNumber;
  final String asset = 'assets/fontpages/QCF${fileNumber}_X-Regular.woff';

  final FontLoader loader = FontLoader(family);
  final ByteData data = await rootBundle.load(asset);
  loader.addFont(Future.value(data));
  await loader.load();
}
