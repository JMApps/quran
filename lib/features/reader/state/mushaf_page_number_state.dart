import 'package:flutter/material.dart';

class MushafPageNumberState extends ChangeNotifier {
  late int _currentPageNumber;

  int get currentPageNumber => _currentPageNumber;

  set currentPageNumber(int pageNumber) {
    _currentPageNumber = pageNumber;
    notifyListeners();
  }
}