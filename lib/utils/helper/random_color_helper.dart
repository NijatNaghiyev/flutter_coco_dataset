import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorHelper {
  static final Random _random = Random();

  static Color getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0,
    );
  }

  static Color getRandomColorWithOpacity(double opacity) {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      opacity,
    );
  }
}