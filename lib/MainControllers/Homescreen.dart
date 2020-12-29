import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:sleek_weather/Colors/ColorsManager.dart';
import 'package:sleek_weather/Weather/Forecast.dart';

import 'package:sleek_weather/main.dart';
import 'package:sleek_weather/Backend/DataManager.dart';
import 'package:sleek_weather/Location/LocationManager.dart';
import 'package:sleek_weather/Weather/BackendWeather.dart';

class Homescreen extends StatefulWidget {
  Function switcher;

  @override
  Homescreen({ this.switcher });
  @override
  _Homescreen createState() => _Homescreen();
}

class _Homescreen extends State<Homescreen> with TickerProviderStateMixin {
  bool _visible = false;
  bool _weather = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            top: _visible ? -300 : -50,
            right: -5,
            duration: const Duration(
              milliseconds: 500,
            ),
            curve: Curves.bounceOut,
            child: Icon(
              Weather.forecast[DataManager.currentLocation].getIconData(),
              size: 250,
              color: Color.fromRGBO(55, 55, 55, 0.5),
            ),
          ),
          AnimatedPositioned(
            top: _visible ? MediaQuery.of(context).size.height : _weather ? -250 : 0,
            duration: const Duration(
              milliseconds: 500,
            ),
            curve: Curves.bounceOut,
            child: Transform.scale(
              scale: _weather ? 2.25 : 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    aspectRatio: 0.8,
                    viewportFraction: 0.85,
                    enableInfiniteScroll: DataManager.locations.length > 1,
                    height: MediaQuery.of(context).size.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        DataManager.currentLocation = index;
                      });
                    },
                  ),
                  items: DataManager.locations.map((weatherLocation) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3,
                            bottom: 60,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 25.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: ColorsManager.colors[DataManager.locations.indexOf(weatherLocation)].colors,
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.3),
                                  blurRadius: 20.0, // has the effect of softening the shadow
                                  spreadRadius: 5.0, // has the effect of extending the shadow
                                  offset: Offset(
                                    10.0, // horizontal, move right 10
                                    10.0, // vertical, move down 10
                                  ),
                                )
                              ],
                            ),
                            child: AnimatedOpacity(
                              opacity: _weather ? 0.0 : 1.0,
                              duration: const Duration(
                                milliseconds: 500,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Text(
                                      weatherLocation.displayName(),
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.5),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 25,
                                    right: 25,
                                    child: Text(
                                      "${Weather.forecast[DataManager.locations.indexOf(weatherLocation)].temperature}°",
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.5),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 90,
                                      right: 30,
                                      left: 30,
                                    ),
                                    child: Text(
                                      "\"Today it feels like ${Weather.forecast[DataManager.locations.indexOf(weatherLocation)].feelsLike}° with a high of ${Weather.forecast[DataManager.locations.indexOf(weatherLocation)].maxTemperature}° and a low of ${Weather.forecast[DataManager.locations.indexOf(weatherLocation)].minTemperature}° and the sky has ${Weather.forecast[DataManager.locations.indexOf(weatherLocation)].description}.\"",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: -75,
                                    bottom: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Weather.forecast[DataManager.locations.indexOf(weatherLocation)].getIconData(),
                                      ),
                                      color: Color.fromRGBO(255, 255, 255, 0.5),
                                      iconSize: MediaQuery.of(context).size.width - 125,
                                      onPressed: () {
                                        // open to controller
                                      },
                                    ),
                                  ),
                                  FlatButton(
                                    child: Container(),
                                    onPressed: () {
                                      setState(() {
                                        _weather = !_weather;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ) ,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 7,
            left: 25,
            child: AnimatedOpacity(
              opacity: _weather ? 1.0 : 0.0,
              duration: const Duration(
                milliseconds: 500,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Text(
                      "${DataManager.locations[DataManager.currentLocation].displayName()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      width: MediaQuery.of(context).size.width - 150,
                      child: Text(
                        "${Weather.summary()}",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Feels Like",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${Weather.forecast[DataManager.currentLocation].feelsLike}°",
                            style: TextStyle(
                              color: Colors.black26,
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _weather ? 0.0 : 1.0,
            duration: const Duration(
              milliseconds: 500,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 25.0,
                      bottom: 8.0
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            _visible ? Icons.close : Icons.sort,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () {
                            widget.switcher();
                            setState(() {
                              _visible = !_visible;

                              if (!_visible) {
                                AdMobWrapper.main.createAd();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    left: _visible ? -MediaQuery.of(context).size.width : 0,
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.bounceOut,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 6,
                        left: 25,
                        right: 25,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 100,
                        child: Stack(
                          children: <Widget>[
                            Text(
                              "${Weather.greeting()}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: const Color.fromRGBO(101, 99, 235, 0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 22,
                                right: 50,
                              ),
                              child: Text(
                                "${Weather.summary()}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(970),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    top: _visible ? 0 : MediaQuery.of(context).size.height,
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.bounceOut,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 75
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.75),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 75,
                        child: LocationManager(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            top: MediaQuery.of(context).size.height / (_weather ? 3.5 : 1),
            duration: const Duration(
              milliseconds: 500,
            ),
            curve: Curves.bounceOut,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / (_weather ? 3.5 : 1)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 35,
                ),
                child: SingleChildScrollView(
                  child: Forecast(
                    forecast: Weather.forecast[DataManager.currentLocation],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(
              milliseconds: 500,
            ),
            top: _weather ? 25 : -50,
            right: 5,
            curve: Curves.bounceOut,
            child: IconButton(
              icon: Icon(
                Icons.close,
              ),
              iconSize: 35,
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _weather = !_weather;

                  if(!_weather) {
                    AdMobWrapper.main.createAd();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}