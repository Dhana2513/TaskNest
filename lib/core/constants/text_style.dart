import 'package:flutter/material.dart';

import '../extensions/text_size.dart';

abstract class UITextStyle {
  //fontSize 18
  static const title = TextStyle(
    fontSize: TextSize.large,
    fontWeight: FontWeight.w700,
    fontFamily: 'ubuntu',
  );

  //fontSize 16
  static const subtitle1 = TextStyle(
    fontSize: TextSize.large - 2.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'ubuntu',
  );

  //fontSize 15
  static const subtitle2 = TextStyle(
    fontSize: TextSize.large - 3.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'ubuntu',
  );

  //fontSize 14
  static const body = TextStyle(
    fontSize: TextSize.basic,
    fontWeight: FontWeight.w500,
    fontFamily: 'ubuntu',
  );

  static const boldBody = TextStyle(
    fontSize: TextSize.basic,
    fontWeight: FontWeight.bold,
    fontFamily: 'ubuntu',
  );


  //fontSize 16
  static const bodyLarge = TextStyle(
    fontSize: TextSize.basic + 2,
    fontWeight: FontWeight.w500,
    fontFamily: 'ubuntu',
  );
}
