import 'package:weather_app/utils/time.dart' show parseUnixTimestamp;

import '../configs.dart' show countryCodesToNames;
import '../utils.dart' show WeatherCondition, parseWeatherCode;
import 'current_weather.dart' show CurrentWeatherResponse;
import 'five_day_forecast.dart' show ForecastResponse;

class WeatherData {
  late final WeatherData$Location location;
  late final List<WeatherData$DataItem> data;

  WeatherData.create({
    required CurrentWeatherResponse current,
    required ForecastResponse forecast,
  }) {
    location = WeatherData$Location(
      country:
          countryCodesToNames[forecast.city.country] ?? forecast.city.country,
      city: forecast.city.name,
      sunriseTime: _parseSunTime(
        timestamp: forecast.city.sunrise,
        tzOffset: forecast.city.timezone,
      ),
      sunsetTime: _parseSunTime(
        timestamp: forecast.city.sunset,
        tzOffset: forecast.city.timezone,
      ),
    );

    final List<WeatherData$DataItem> weatherData = [];
    weatherData.add(
      WeatherData$DataItem(
        dateTime: parseUnixTimestamp(current.dt),
        weatherCondition: parseWeatherCode(current.weather[0].id),
        temperature: current.main.temp,
        temperatureFeel: current.main.feels_like,
      ),
    );
    weatherData.addAll([
      for (final data in forecast.list)
        WeatherData$DataItem(
          dateTime: parseUnixTimestamp(data.dt),
          weatherCondition: parseWeatherCode(data.weather[0].id),
          temperature: data.main.temp,
          temperatureFeel: data.main.feels_like,
        ),
    ]);
    data = weatherData;
  }

  static _parseSunTime({required int timestamp, required int tzOffset}) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    ).add(Duration(seconds: tzOffset));
  }
}

class WeatherData$Location {
  final String country;
  final String city;
  final DateTime sunriseTime;
  final DateTime sunsetTime;

  const WeatherData$Location({
    required this.country,
    required this.city,
    required this.sunriseTime,
    required this.sunsetTime,
  });
}

class WeatherData$DataItem {
  final DateTime dateTime;
  final WeatherCondition weatherCondition;
  final double temperature;
  final double temperatureFeel;

  const WeatherData$DataItem({
    required this.dateTime,
    required this.weatherCondition,
    required this.temperature,
    required this.temperatureFeel,
  });
}
