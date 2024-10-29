// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required AppConfig$WeatherService weatherService,
  }) = _AppConfig;
}

@freezed
class AppConfig$WeatherService with _$AppConfig$WeatherService {
  const factory AppConfig$WeatherService({
    required String appId,
    required String dataFormatVersion,
    required String dataFormatVersionStorageKey,
    required String storageKey,
  }) = _AppConfig$WeatherService;
}

final appConfig = AppConfig(
  weatherService: AppConfig$WeatherService(
    appId: dotenv.get('WEATHER_SERVICE_APP_ID'),
    dataFormatVersion: '0',
    dataFormatVersionStorageKey: 'dataFormatVersion',
    storageKey: 'weatherData',
  ),
);
