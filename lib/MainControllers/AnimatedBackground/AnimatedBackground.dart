import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:sleek_weather/MainControllers/AnimatedBackground/GradientAnimation.dart';
import 'package:sleek_weather/MainControllers/AnimatedBackground/WaveAnimation.dart';

class Background extends StatefulWidget {
  @override
  _Background createState() => _Background();
}

class _Background extends State<Background> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedBackground()
          ),
          AnimatedWave.onBottom(
            AnimatedWave(
              height: 180,
              speed: 1.0,
            )
          ),
          AnimatedWave.onBottom(
            AnimatedWave(
              height: 120,
              speed: 0.9,
              offset: pi,
            )
          ),
          AnimatedWave.onBottom(
            AnimatedWave(
              height: 220,
              speed: 1.2,
              offset: pi / 2,
            )
          ), 
        ],
      )
    );
  }
}