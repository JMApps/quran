import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowAppBarState extends ChangeNotifier {
  bool _showAppBar = true;

  bool get showAppBar => _showAppBar;

  void changeShowingAppBar() {
    _showAppBar = !_showAppBar;
    _showAppBar ? _showSystemUiWithDelay() : _hideSystemUiWithDelay();
    notifyListeners();
  }

  Future<void> _showSystemUiWithDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  Future<void> _hideSystemUiWithDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 125));
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    unawaited(_showSystemUiWithDelay());
    super.dispose();
  }
}