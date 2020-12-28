import 'dart:core';

import 'package:dio/dio.dart';

class ServerSide {
  Map<String, String> API_KEY = {
    "PLACES": "AIzaSyBiJYOnWlcNV9QxNE5PphsSam-LrtaYGps",
    "OPENWEATHERMAP": "c43dc67f50678fa8deb7d820b8cc9f69",
    "DARKKSKY": "2bdd9d8cfb0c5c46d2e953979e07dde6",
  };

  Map<String, String> API_HEADER = {
    "PLACES": "key",
    "OPENWEATHERMAP": "appid",
    "DARKSKY": "",
  };

  String baseURL = '';
  String arguments = '';

  ServerSide(this.baseURL, this.arguments);

  Future<Response> access(String type) async {
    print('$baseURL?$arguments&${API_HEADER[type]}=${API_KEY[type]}'.replaceAll(" ", "+"));
    return await Dio().get('$baseURL?$arguments&${API_HEADER[type]}=${API_KEY[type]}'.replaceAll(" ", "+"));
  }
}