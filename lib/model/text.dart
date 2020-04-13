/*
 * This file contain all generic designs for text
 */

import 'package:ba_locale/model/style.dart';
import 'package:flutter/material.dart';

class TextInterfaceDesign extends Text{
  TextInterfaceDesign (String text, {double size})
      : super (
      text,
      style: TextStyle(
        color: ThemeDesign.interfaceTxtColor,
        fontSize: size,
      )
  );
}

class TextParagraphDesign extends Text{
  TextParagraphDesign (String text, {double size})
      : super (
      text,
      style: TextStyle(
        color: ThemeDesign.mainTxtColor,
        fontSize: size,
      )
  );
}

class TextTitleDesign extends Text{
  TextTitleDesign (String text, {double size})
      : super (
      text,
      style: ThemeDesign.titleStyle
  );
}