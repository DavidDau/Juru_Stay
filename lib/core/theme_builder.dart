import 'package:flutter/material.dart';



ThemeData buildTheme(String fontSize, Brightness brightness) {
  double scale;

  switch (fontSize) {
    case 'small':
      scale = 0.8;
      break;
    case 'large':
      scale = 1.3;
      break;
    case 'medium':
    default:
      scale = 1.0;
      break;
  }

  final base = brightness == Brightness.dark
      ? ThemeData.dark()
      : ThemeData.light();

  return base.copyWith(
    textTheme: base.textTheme.apply(fontSizeFactor: scale),
  );
}

