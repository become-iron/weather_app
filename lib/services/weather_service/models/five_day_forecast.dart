// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'five_day_forecast.freezed.dart';
part 'five_day_forecast.g.dart';

@freezed
class ForecastResponse with _$ForecastResponse {
  const factory ForecastResponse({
    required String cod,
    required int message,
    required int cnt,
    required List<Forecast$ListItem> list,
    required Forecast$City city,
  }) = _ForecastResponse;

  factory ForecastResponse.fromJson(Map<String, Object?> json) =>
      _$ForecastResponseFromJson(json);
}

@freezed
class Forecast$ListItem with _$Forecast$ListItem {
  const factory Forecast$ListItem({
    required int dt,
    required Forecast$ListItem$Main main,
    required List<Forecast$ListItem$WeatherItem> weather,
    required Map<String, Object> clouds,
    required Map<String, Object> wind,
    required int visibility,
    required int pop,
    required Map<String, Object>? rain,
    required Map<String, Object>? snow,
    required Map<String, Object> sys,
    required String dt_txt,
  }) = _Forecast$ListItem;

  factory Forecast$ListItem.fromJson(Map<String, Object?> json) =>
      _$Forecast$ListItemFromJson(json);
}

@freezed
class Forecast$ListItem$Main with _$Forecast$ListItem$Main {
  const factory Forecast$ListItem$Main({
    required double temp,
    required double feels_like,
    required double temp_min,
    required double temp_max,
    required double pressure,
    required double sea_level,
    required double grnd_level,
    required double humidity,
    required double temp_kf,
  }) = _Forecast$ListItem$Main;

  factory Forecast$ListItem$Main.fromJson(Map<String, Object?> json) =>
      _$Forecast$ListItem$MainFromJson(json);
}

@freezed
class Forecast$ListItem$WeatherItem with _$Forecast$ListItem$WeatherItem {
  const factory Forecast$ListItem$WeatherItem({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _Forecast$ListItem$WeatherItem;

  factory Forecast$ListItem$WeatherItem.fromJson(Map<String, Object?> json) =>
      _$Forecast$ListItem$WeatherItemFromJson(json);
}

@freezed
class Forecast$City with _$Forecast$City {
  const factory Forecast$City({
    required int id,
    required String name,
    required Map<String, double> coord,
    required String country,
    required int population,
    required int timezone,
    required int sunrise,
    required int sunset,
  }) = _Forecast$City;

  factory Forecast$City.fromJson(Map<String, Object?> json) =>
      _$Forecast$CityFromJson(json);
}
