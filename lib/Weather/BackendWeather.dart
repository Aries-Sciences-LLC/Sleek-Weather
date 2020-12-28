import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:sleek_weather/main.dart';
import 'package:sleek_weather/Weather/WeatherIconMapper.dart';
import 'package:sleek_weather/Backend/DataManager.dart';
import 'package:sleek_weather/Backend/ServerSide.dart';

class Weather {
  static bool status = false;
  static List<Weather> forecast;
  static List<String> summaries;

  final int id;
  final int time;
  final int sunrise;
  final int sunset;
  final int humidity;

  final String description;
  final String iconCode;
  final String cityName;

  final double windSpeed;

  final int feelsLike;
  final int temperature;
  final int maxTemperature;
  final int minTemperature;

  List<CardData> forecastCards;
  List<WeekDay> weekdays;

  Weather(
    {
      this.id,
      this.time,
      this.sunrise,
      this.sunset,
      this.humidity,
      this.description,
      this.iconCode,
      this.cityName,
      this.windSpeed,
      this.feelsLike,
      this.temperature,
      this.maxTemperature,
      this.minTemperature,
      this.forecastCards,
      this.weekdays,
    }
  );

  static void setupWeatherData() {
    Weather.forecast = List();
    Weather.summaries = List();
    Weather.fetchData();
  }

  static void fetchData() {
    print(DataManager.locations);
    for(int i = 0; i < DataManager.locations.length; i++) {
      double latitude = DataManager.locations[i].latitude;
      double longitude = DataManager.locations[i].longitude;
      ServerSide("https://api.openweathermap.org/data/2.5/weather", "lat=$latitude&lon=$longitude&units=imperial").access("OPENWEATHERMAP").then(
        (weatherData) {
          print("Got em");
          forecast.add(Weather.fromJson(weatherData.data));
          summaries.add("It's ${weatherData.data['main']['temp'].toDouble().round()}° with ${weatherData.data['weather'][0]['description']}.");

          if (i == DataManager.locations.length - 1) {
            Weather.setupCards();
          }
        }
      );
    }
  }

  static void setupCards() {
    for(int i = 0; i < DataManager.locations.length; i++) {
      double latitude = DataManager.locations[i].latitude;
      double longitude = DataManager.locations[i].longitude;
      ServerSide("https://api.darksky.net/forecast/2bdd9d8cfb0c5c46d2e953979e07dde6/$latitude,$longitude", "exclude=currently,minutely,flags").access("DARKSKY").then(
        (weatherData) {

          List<dynamic> cardData = weatherData.data["hourly"]["data"];
          for(int j = 0; j < cardData.length; j++) {
            forecast[i].forecastCards.add(CardData(
              icon: Weather.darkSkyIcons(cardData[j]["icon"]),
              temperature: cardData[j]["temperature"].toDouble().round(),
              time: "${Weather.darkSkyTime(DateTime.fromMillisecondsSinceEpoch(cardData[j]["time"].toDouble().round() * 1000).hour)}",
            ));
          }

          List<dynamic> weekdayData = weatherData.data["daily"]["data"];
          for (int j = 0; j < weekdayData.length; j++) {
            forecast[i].weekdays.add(WeekDay(
              icon: Weather.darkSkyIcons(cardData[j]["icon"]),
              temperature: (weekdayData[j]["temperatureHigh"].toDouble().round() - (weekdayData[j]["temperatureHigh"].toDouble().round() / weekdayData[j]["temperatureLow"].toDouble().round())).round(),
              day: Weather.darkSkyWeekTime(weekdayData[j]["time"].toDouble().round()),
            ));
          }

          if (i == DataManager.locations.length - 1) {
            status = true;
            main();
          }
        }
      );
    }
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['weather'][0]['id'],
      time: json['dt'],
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      cityName: json['name'],
      feelsLike: json['main']['feels_like'].toDouble().round(),
      temperature: json['main']['temp'].toDouble().round(),
      maxTemperature: json['main']['temp_max'].toDouble().round(),
      minTemperature: json['main']['temp_min'].toDouble().round(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as double),
      forecastCards: List<CardData>(),
      weekdays: List<WeekDay>(),
    );
  }

  static String summary() {
    return Weather.summaries[DataManager.currentLocation];
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  IconData getIconData() {
    switch (this.iconCode) {
      case '01d': return                    WeatherIcons.clear_day;
      case '01n': return                  WeatherIcons.clear_night;
      case '02d': return               WeatherIcons.few_clouds_day;
      case '02n': return               WeatherIcons.few_clouds_day;
      case '03d': return                   WeatherIcons.clouds_day;
      case '04d': return                   WeatherIcons.clouds_day;
      case '03n': return                  WeatherIcons.clear_night;
      case '04n': return                  WeatherIcons.clear_night;
      case '09d': return              WeatherIcons.shower_rain_day;
      case '09n': return            WeatherIcons.shower_rain_night;
      case '10d': return                     WeatherIcons.rain_day;
      case '10n': return                   WeatherIcons.rain_night;
      case '11d': return            WeatherIcons.thunder_storm_day;
      case '11n': return          WeatherIcons.thunder_storm_night;
      case '13d': return                     WeatherIcons.snow_day;
      case '13n': return                   WeatherIcons.snow_night;
      case '50d': return                     WeatherIcons.mist_day;
      case '50n': return                   WeatherIcons.mist_night;
      default: return                       WeatherIcons.clear_day;
    }
  }

  static IconData darkSkyIcons(String icon) {
    switch (icon) {
      case 'clear-day': return              WeatherIcons.clear_day;
      case 'clear-night': return          WeatherIcons.clear_night;
      case 'rain': return                    WeatherIcons.rain_day;
      case 'sleet': return                   WeatherIcons.snow_day;
      case 'snow': return                    WeatherIcons.snow_day;
      case 'wind': return                    WeatherIcons.mist_day;
      case 'fog': return                     WeatherIcons.mist_day;
      case 'cloudy': return                WeatherIcons.clouds_day;
      case 'partly-cloudy-day': return     WeatherIcons.clouds_day;
      case 'partly-cloudy-night': return WeatherIcons.clouds_night;
      default: return                       WeatherIcons.clear_day;
    }
  }

  static String darkSkyTime(int time) {
    return time < 12 ? "${time == 0 ? 12 : time} AM" : "${((time - 12) == 0 ? 12 : time - 12)} PM";
  }

  static String darkSkyWeekTime(int time) {
    return DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
  }

  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    if (time.substring(time.length - 2) == "PM") {
      time = (int.parse(time.substring(0, 2)) - 12).toString() + time.substring(2);
    }

    if (time.substring(0, 1) == "0") {
      time = time.substring(1);
    }

    return time;
  }
}

class CardData {
  IconData icon;
  int temperature;
  String time;

  CardData({ this.icon, this.temperature, this.time });
}

class WeekDay {
  String day;
  int temperature;
  IconData icon;

  WeekDay({ this.icon, this.temperature, this.day });
}