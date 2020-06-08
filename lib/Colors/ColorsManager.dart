import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sleek_weather/Backend/DataManager.dart';

class GradientColor {
  final String name;
  final List<Color> colors;

  GradientColor(
    {
      this.name,
      this.colors,
    }
  );
}

class ColorsManager {
  static List<GradientColor> colors;
  static int currentGradient;

  static Future<void> setupColorValues() async {
    colors = List<GradientColor>();

    List<dynamic> data = ((await DataManager.parseJSONFromAssets("lib/Colors/Gradients.json")) as List<dynamic>);

    for (Map<String, dynamic> colorData in data) {
      List<Color> gradient = List<Color>();
      for (String color in (colorData['colors'] as List<dynamic>)) {
        gradient.add(HexColor.fromHex(color));
      }
      colors.add(GradientColor(name: colorData['name'], colors: gradient));
    }

    colors.shuffle();
  }
}

class HexColor extends Color {
  HexColor(int value) : super(value);

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}