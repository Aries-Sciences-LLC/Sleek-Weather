import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:app_settings/app_settings.dart';
import 'package:sleek_weather/main.dart';

import 'dart:ui';

import 'package:sleek_weather/Backend/Transitions.dart';

class InternetErrorController extends StatefulWidget {
  @override
  _InternetErrorController createState() => _InternetErrorController();
}

class _InternetErrorController extends State<InternetErrorController> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(
        seconds: 1
      ),
      child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeIn(
              0.0, 
              Center(
                child: Icon(
                  Icons.signal_wifi_off,
                  size: 100.0,
                  color: Colors.white,
                ),
              ),
            ),
            FadeIn(
              0.5,
              Padding(
                padding: const EdgeInsets.all(2.5),
                child: Center(
                  child: Text(
                    "Whoops!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                    ),
                  ),
                ),
              ),
            ),
            FadeIn(
              1.0,
              Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                child: Center(
                  child: Text(
                    "There's no network connection, Make sure you're connected to a Wi-fi or moblie netowork and try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            FadeIn(
              1.5,
              Padding(
                padding: const EdgeInsets.only(
                  left: 0.0,
                  right: 0.0,
                  top: 10.0,
                  bottom: 0.0,
                ),
                child: Center(
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width - 50,
                    height: 45,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(22.5),
                      ),
                      onPressed: this.refresh,
                      color: Colors.white,
                      child: Icon(
                        Icons.refresh
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FadeIn(
              2.0,
              Padding(
                padding: const EdgeInsets.only(
                  left: 0.0,
                  right: 0.0,
                  top: 10.0,
                  bottom: 0.0,
                ),
                child: Center(
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width - 50,
                    height: 45,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(22.5),
                      ),
                      onPressed: this.openWifiPrefrences,
                      color: Colors.white,
                      child: Icon(
                        Icons.settings
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  void refresh() {
    connectivityProtocol.checkConnection();

    if (connectivityProtocol.hasConnection) {
      setState(() {
        _visible = false;
      });
      
      Future.delayed(const Duration(seconds: 1), main);
    }
  }

  void openWifiPrefrences() {
    AppSettings.openWIFISettings();
  }
}