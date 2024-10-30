import 'package:flutter/material.dart' show IconData;
import 'package:material_symbols_icons/symbols.dart' show Symbols;

// source: https://openweathermap.org/weather-conditions
// TODO: some weather conditions doesn't have appropriate icons
enum WeatherCondition {
  thunderstorm(label: 'Thunderstorm', icon: Symbols.thunderstorm),
  drizzle(label: 'Drizzle', icon: Symbols.rainy_light),
  rain(label: 'Rain', icon: Symbols.rainy),
  snow(label: 'Snow', icon: Symbols.weather_snowy),
  mist(label: 'Mist', icon: Symbols.mist),
  smoke(label: 'Smoke'),
  haze(label: 'Haze'),
  dust(label: 'Dust'),
  fog(label: 'Fog', icon: Symbols.foggy),
  sand(label: 'Sand'),
  ash(label: 'Ash'),
  squall(label: 'Squall'),
  tornado(label: 'Tornado', icon: Symbols.tornado),
  clear(label: 'Clear', icon: Symbols.clear_day),
  clouds(label: 'Clouds', icon: Symbols.cloudy),
  // for example, to handle new conditions
  // that not supported by the app, yet
  unknownWeather(label: 'Unknown');

  const WeatherCondition({
    required this.label,
    this.icon = Symbols.help,
  });

  final String label;
  final IconData icon;
}

WeatherCondition parseWeatherCode(int code) {
  return switch (code) {
    >= 200 && <= 232 => WeatherCondition.thunderstorm,
    >= 300 && <= 321 => WeatherCondition.drizzle,
    >= 500 && <= 531 => WeatherCondition.rain,
    >= 600 && <= 622 => WeatherCondition.snow,
    == 701 => WeatherCondition.mist,
    == 711 => WeatherCondition.smoke,
    == 721 => WeatherCondition.haze,
    == 731 || == 761 => WeatherCondition.dust,
    == 741 => WeatherCondition.fog,
    == 751 => WeatherCondition.sand,
    == 762 => WeatherCondition.ash,
    == 771 => WeatherCondition.squall,
    == 781 => WeatherCondition.tornado,
    == 800 => WeatherCondition.clear,
    >= 801 && <= 804 => WeatherCondition.clouds,
    _ => WeatherCondition.unknownWeather
  };
}
