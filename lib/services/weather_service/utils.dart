import 'package:flutter/material.dart' show IconData;
import 'package:material_symbols_icons/symbols.dart' show Symbols;

// source: https://openweathermap.org/weather-conditions
// TODO: there are no icons for all weather conditions
IconData weatherCodeToIcon(int code) {
  return switch (code) {
    >= 200 && <= 232 => Symbols.thunderstorm,
    >= 300 && <= 321 => Symbols.rainy_light,
    >= 500 && <= 531 => Symbols.rainy,
    >= 600 && <= 622 => Symbols.weather_snowy,
    == 701 => Symbols.mist,
    // == 711 => Symbols., // Smoke
    // == 721 => Symbols., // Haze
    // == 731 => Symbols., // Dust
    == 741 => Symbols.foggy,
    // == 751 => Symbols.,  // Sand
    // == 761 => Symbols.,  // Dust
    // == 762 => Symbols.,  // Ash
    // == 771 => Symbols.,  // Squall
    == 781 => Symbols.tornado,
    == 800 => Symbols.clear_day,
    >= 801 && <= 804 => Symbols.cloudy,
    _ => Symbols.help
  };
}
