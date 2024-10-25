import 'package:flutter/material.dart';

class WeatherData {
  final String date;
  final int temperature;
  final Icon icon;

  const WeatherData({
    required this.date,
    required this.temperature,
    required this.icon,
  });
}
