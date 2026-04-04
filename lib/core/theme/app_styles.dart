import 'package:flutter/material.dart';

class AppStyles {
  static const mainPadding = EdgeInsets.all(14);
  static const miniPadding = EdgeInsets.all(7);
  static const microPadding = EdgeInsets.all(3.5);
  static const hrMainPadding = EdgeInsets.symmetric(horizontal: 14);
  static const hrMiniPadding = EdgeInsets.symmetric(horizontal: 7);
  static const vrMainPadding = EdgeInsets.symmetric(vertical: 14);
  static const vrMiniPadding = EdgeInsets.symmetric(vertical: 7);
  static const vrBigHrMiniPadding = EdgeInsets.symmetric(vertical: 21, horizontal: 7);
  static const topMiniPadding = EdgeInsets.only(top: 7);
  static const bottomMainPadding = EdgeInsets.only(bottom: 14);

  static const withoutTopPadding = EdgeInsets.only(left: 14, bottom: 14, right: 14);
  static const withoutTopPaddingMini = EdgeInsets.only(left: 7, bottom: 7, right: 7);
  static const withoutRightPaddingMini = EdgeInsets.only(left: 7, top: 7, bottom: 7);

  static const mainBorder = BorderRadius.all(Radius.circular(14));
  static const miniBorder = BorderRadius.all(Radius.circular(7));

  static const bigShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(21)));
  static const mainShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)));
  static const miniShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)));
}