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
  final weatherServiceHost = 'api.openweathermap.org';

  Future<void> init() async {
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

  // Future<ForecastResponse?> getCachedWeatherData() async {
  //   final config = appConfig.weatherService;
  //   final storage = SharedPreferencesAsync();
  //   final String? cachedData = await storage.getString(config.storageKey);
  //   return cachedData == null
  //       ? null
  //       : ForecastResponse.fromJson(jsonDecode(cachedData));
  // }

  // Docs: https://openweathermap.org/current
  Future<String> _getCurrentWeather({
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
  Future<String> _getForecast({
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

  WeatherData _parseWeatherData({
    required String current,
    required String forecast,
  }) {
    return WeatherData.create(
      current: CurrentWeatherResponse.fromJson(jsonDecode(current)),
      forecast: ForecastResponse.fromJson(jsonDecode(forecast)),
    );
  }

  Future<void> _storeWeatherData({
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
  }

  Future<WeatherData?> _restoreWeatherData({
    required String current,
    required String forecast,
  }) async {
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

    final data = await storage.getString(config.storageKey);
    if (data == null) {
      return null;
    }

    // FIXME: should fail on incorrect format
    final {
      'current': current,
      'forecast': forecast,
    } = jsonDecode(data) as Map<String, String>;

    return _parseWeatherData(
      current: current,
      forecast: forecast,
    );
  }

  Future<WeatherData> getWeatherData({
    required Position position,
    int? count,
  }) async {
    final [current, forecast] = await Future.wait([
      _getCurrentWeather(position: position),
      _getForecast(position: position, count: count),
    ]);

    await _storeWeatherData(current: current, forecast: forecast);

    // final config = appConfig.weatherService;
    // final storage = SharedPreferencesAsync();
    // await storage.setString(config.storageKey, forecast);
    // await storage.setString(
    //   config.dataFormatVersionStorageKey,
    //   config.dataFormatVersion,
    // );

    return _parseWeatherData(current: current, forecast: forecast);
    // return WeatherData.create(
    //   current: CurrentWeatherResponse.fromJson(jsonDecode(current)),
    //   forecast: ForecastResponse.fromJson(jsonDecode(forecast)),
    // );
  }
}
