import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:geolocator/geolocator.dart' show Position;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;
import 'package:weather_app/configs/app_config.dart' show appConfig;
import 'package:weather_app/utils/logger.dart' show logger;

import 'models/current_weather.dart' show CurrentWeatherResponse;
import 'models/five_day_forecast.dart' show ForecastResponse;
import 'models/weather_data.dart' show WeatherData;

class WeatherService {
  static const weatherServiceHost = 'api.openweathermap.org';

  static Future<void> init() async {
    final config = appConfig.weatherService;
    final storage = SharedPreferencesAsync();
    final String? formatVersion =
        await storage.getString(config.dataFormatVersionStorageKey);
    if (formatVersion != config.dataFormatVersion) {
      logger.d(
        'Remove cached weather data since it has different format version. '
        'Stored: $formatVersion. Current: ${config.dataFormatVersion}',
      );
      await storage.remove(config.storageKey);
    }
  }

  // Docs: https://openweathermap.org/current
  static Future<String> _getCurrentWeather({
    required Position position,
  }) async {
    final response = await http.get(Uri.https(
      weatherServiceHost,
      '/data/2.5/weather',
      {
        'lat': '${position.latitude}',
        'lon': '${position.longitude}',
        'appid': appConfig.weatherService.appId,
        'units': 'metric',
      },
    ));
    return response.body;
  }

  // Docs: https://openweathermap.org/forecast5
  static Future<String> _getForecast({
    required Position position,
    int? count,
  }) async {
    final response = await http.get(Uri.https(
      weatherServiceHost,
      '/data/2.5/forecast',
      {
        'lat': '${position.latitude}',
        'lon': '${position.longitude}',
        'appid': appConfig.weatherService.appId,
        'units': 'metric',
        if (count != null) 'cnt': '$count',
      },
    ));
    return response.body;
  }

  static WeatherData _parseWeatherData({
    required String current,
    required String forecast,
  }) {
    return WeatherData.create(
      current: CurrentWeatherResponse.fromJson(jsonDecode(current)),
      forecast: ForecastResponse.fromJson(jsonDecode(forecast)),
    );
  }

  static Future<WeatherData> getWeatherData({
    required Position position,
    int? count,
  }) async {
    final [current, forecast] = await Future.wait([
      _getCurrentWeather(position: position),
      _getForecast(position: position, count: count),
    ]);
    logger.d('Fetched weather data');
    await _storeWeatherData(current: current, forecast: forecast);
    final weatherData = _parseWeatherData(current: current, forecast: forecast);
    logger.d('Parsed weather data');
    return weatherData;
  }

  static Future<void> _storeWeatherData({
    required String current,
    required String forecast,
  }) async {
    final config = appConfig.weatherService;
    final storage = SharedPreferencesAsync();

    await storage.setString(
      config.storageKey,
      jsonEncode({
        'current': current,
        'forecast': forecast,
      }),
    );
    await storage.setString(
      config.dataFormatVersionStorageKey,
      config.dataFormatVersion,
    );

    logger.d('Stored weather data');
  }

  static Future<void> _clearStoredWeatherData() async {
    final config = appConfig.weatherService;
    final storage = SharedPreferencesAsync();

    await storage.remove(config.storageKey);
    await storage.remove(config.dataFormatVersionStorageKey);

    logger.d('Cleared stored weather data');
  }

  static Future<WeatherData?> getCachedWeatherData() async {
    final config = appConfig.weatherService;
    final storage = SharedPreferencesAsync();

    final String? formatVersion =
        await storage.getString(config.dataFormatVersionStorageKey);
    if (formatVersion != config.dataFormatVersion) {
      logger.d('Stored weather data has a different ($formatVersion) '
          'format version than the current one (${config.dataFormatVersion})');
      await storage.remove(config.storageKey);
      await _clearStoredWeatherData();
    }

    final data = await storage.getString(config.storageKey);
    if (data == null) {
      return null;
    }

    try {
      final {
        'current': current as String,
        'forecast': forecast as String,
      } = jsonDecode(data);
      final weatherData = _parseWeatherData(
        current: current,
        forecast: forecast,
      );
      logger.d('Restored weather data');
      return weatherData;
    } catch (e) {
      logger.e('Stored weather data seems to have incorrect format', error: e);
      await _clearStoredWeatherData();
      return null;
    }
  }
}
