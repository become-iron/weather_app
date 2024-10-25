// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';

@freezed
class WeatherServiceConfig with _$WeatherServiceConfig {
  const factory WeatherServiceConfig({
    required String appId,
  }) = _WeatherServiceConfig;
}

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required WeatherServiceConfig weatherService,
  }) = _AppConfig;
}

final appConfig = AppConfig(
  weatherService: WeatherServiceConfig(
    appId: dotenv.get('WEATHER_SERVICE_APP_ID'),
  ),
);
