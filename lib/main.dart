import 'package:flutter/material.dart';
import 'package:sleek_weather/Backend/DataManager.dart';
import 'package:sleek_weather/Colors/ColorsManager.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:sleek_weather/MainControllers/Homescreen.dart';
import 'package:sleek_weather/MainControllers/InternetError.dart';
import 'package:sleek_weather/MainControllers/AnimatedBackground/AnimatedBackground.dart';
import 'package:sleek_weather/Backend/ConnectionStatusSingleton.dart';
import 'package:sleek_weather/Location/BackendLocation.dart';
import 'package:sleek_weather/MainControllers/Loadingscreen.dart';
import 'package:sleek_weather/Weather/BackendWeather.dart';

ConnectionStatusSingleton connectivityProtocol = ConnectionStatusSingleton.getInstance();

void main() {
  runApp(
    MaterialApp(
      home: SleekWeather(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class SleekWeather extends StatefulWidget {
  @override
  _SleekWeather createState() => new _SleekWeather();
}

class _SleekWeather extends State<SleekWeather> {

  AppStructure APPSTRUCTURE;

  @override
  void initState() {
    super.initState();
    ColorsManager.setupColorValues();
    Location.setupLocations(() {
      Weather.setupWeatherData();
    });

    APPSTRUCTURE = AppStructure();
    APPSTRUCTURE.controllers[0] = Positioned(
      top: APPSTRUCTURE.switcher ? 30 : 0,
      child: Container(
          decoration: BoxDecoration(
          borderRadius: APPSTRUCTURE.switcher ? null : BorderRadius.all(
            Radius.circular(25),
          )
        ),
        child: Background(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    connectivityProtocol.connectionChange.listen((connection) {
      if (!connection) {
        APPSTRUCTURE.setMainController(InternetErrorController());
      } else {
        APPSTRUCTURE.setupData();
        APPSTRUCTURE.setMainController(Loadingscreen());
      }
    });

    if (!DataManager.verifiedData()) {
      APPSTRUCTURE.setMainController(Loadingscreen());
    } else {
      APPSTRUCTURE.setMainController(Homescreen(
        switcher: () {
          setState(() {
            APPSTRUCTURE.switcher = !APPSTRUCTURE.switcher;
          });
        }
      ));
    }

    return Scaffold(
      body: Stack(
        children: APPSTRUCTURE.controllers,
      ),
    );
  }
}

class AppStructure {
  bool switcher;
  AdMobWrapper adMob;

  List<Widget> controllers = List<Widget>(2);

  AppStructure() {
    connectivityProtocol.initialize();
    connectivityProtocol.checkConnection();
    switcher = false;

    AdMobWrapper.main = AdMobWrapper(
      AdMobTokens(
        "ca-app-pub-7352520433824678~4784434260",
        "ca-app-pub-7352520433824678/8994060442"
      )
    );
  }

  void setupData() {
    Weather.setupWeatherData();
  }

  void setMainController(StatefulWidget controller) {
    controllers[1] = controller;
  }
}

class AdMobWrapper {
  static AdMobWrapper main;

  AdMobTokens tokens;
  AdmobInterstitial interstitialAd;

  AdMobWrapper(AdMobTokens tokens) {
    this.tokens = tokens;

    interstitialAd = AdmobInterstitial(
      adUnitId: this.tokens.adUnitID,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        if (event == AdmobAdEvent.failedToLoad) {
          print("Error code: ${args['errorCode']}");
        }
      },
    );

    interstitialAd.load();
  }

  void createAd() {
    interstitialAd.show();
  }
}
class AdMobTokens {
  String appID;
  String adUnitID;

  AdMobTokens(String appID, String adUnitID) {
    this.appID = appID;
    this.adUnitID = adUnitID;
  }
}