import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/surah_state.dart';

import 'features/library/presentation/surahs/pages/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SurahState(),
        ),
      ],
      child: const RootPage(),
    ),
  );
}
