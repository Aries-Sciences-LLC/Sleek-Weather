import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:app_settings/app_settings.dart';

class Loadingscreen extends StatefulWidget {
  @override
  _Loadingscreen createState() => _Loadingscreen();
}

class _Loadingscreen extends State<Loadingscreen> with TickerProviderStateMixin {
  double display = 0.0;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        display = 1.0;
      });
    });
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: SpinKitRing(
              color: Colors.white,
              size: 75,
            ),
          ),
          Positioned(
            top: 35,
            left: 25,
            width: MediaQuery.of(context).size.width - 50,
            child: AnimatedOpacity(
              duration: Duration(seconds: 2),
              opacity: display,
              child: FlatButton(
                onPressed: () {
                  AppSettings.openLocationSettings();
                },
                child: Text(
                  "If it hasn't loaded yet, try checking the location prefrences for the app here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}