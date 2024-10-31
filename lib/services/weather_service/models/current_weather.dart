// ignore_for_file: non_constant_identifier_names
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_weather.freezed.dart';
part 'current_weather.g.dart';

@freezed
class CurrentWeatherResponse with _$CurrentWeatherResponse {
  const factory CurrentWeatherResponse({
    required Map<String, double> coord,
    required List<CurrentWeatherResponse$WeatherItem> weather,
    required String base,
    required CurrentWeatherResponse$Main main,
    required int visibility,
    required Map<String, double> wind,
    required Map<String, double> clouds,
    required int dt,
    required Map<String, Object> sys,
    required int timezone,
    required int id,
    required String name,
    required int cod,
  }) = _CurrentWeatherResponse;

  factory CurrentWeatherResponse.fromJson(Map<String, Object?> json) =>
      _$CurrentWeatherResponseFromJson(json);
}

@freezed
class CurrentWeatherResponse$WeatherItem
    with _$CurrentWeatherResponse$WeatherItem {
  const factory CurrentWeatherResponse$WeatherItem({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _CurrentWeatherResponse$WeatherItem;

  factory CurrentWeatherResponse$WeatherItem.fromJson(
          Map<String, Object?> json) =>
      _$CurrentWeatherResponse$WeatherItemFromJson(json);
}

@freezed
class CurrentWeatherResponse$Main with _$CurrentWeatherResponse$Main {
  const factory CurrentWeatherResponse$Main({
    required double temp,
    required double feels_like,
    required double temp_min,
    required double temp_max,
    required double pressure,
    required double humidity,
    required double sea_level,
    required double grnd_level,
  }) = _CurrentWeatherResponse$Main;

  factory CurrentWeatherResponse$Main.fromJson(Map<String, Object?> json) =>
      _$CurrentWeatherResponse$MainFromJson(json);
}
