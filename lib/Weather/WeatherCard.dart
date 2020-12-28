import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

import 'package:sleek_weather/Weather/BackendWeather.dart';

class WeatherCard extends StatefulWidget {
  CardData data;

  @override
  WeatherCard({ this.data });
  @override
  _WeatherCard createState() => _WeatherCard();
}

class _WeatherCard extends State<WeatherCard> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 75,
      child: Stack(
        children: <Widget>[
          Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5,
                  ),
                  child: Text(
                    widget.data.time,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  widget.data.icon,
                  size: 20,
                  color: Colors.black45,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Text(
                    "${widget.data.temperature}°",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 72,
              right: 1,
            ),
            child: Container(
              width: 1.5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(0.75)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}