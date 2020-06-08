import 'dart:core';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:sleek_weather/Location/BackendLocation.dart';
import 'package:sleek_weather/Weather/BackendWeather.dart';

class DataManager {
  static String PREFRENCES_KEY = "locations";
  static List<Location> locations = [];
  static int currentLocation = 0;

  static Future<List<dynamic>> parseJSONFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath).then((jsonStr) => jsonDecode(jsonStr));
  }

  static bool verifiedData() {
    return Weather.status;
  }
}