import 'package:flutter/material.dart';

class AppStyles {
  static const mainPadding = EdgeInsets.all(16);
  static const miniPadding = EdgeInsets.all(16);
  static const hrMainPadding = EdgeInsets.symmetric(horizontal: 16);
  static const hrMiniPadding = EdgeInsets.symmetric(horizontal: 8);
  static const vrMainPadding = EdgeInsets.symmetric(vertical: 16);
  static const vrMiniPadding = EdgeInsets.symmetric(vertical: 8);

  static const mainBorder = BorderRadius.all(Radius.circular(14));
  static const borderMini = BorderRadius.all(Radius.circular(7));

  static const bigShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(21)));
  static const mainShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)));
  static const miniShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)));
}