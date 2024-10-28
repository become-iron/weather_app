import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/pages/home_page/configs.dart'
    show countryCodesToNames;
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart'
    show ForecastResponse;
import 'package:weather_app/services/weather_service/utils.dart'
    show weatherCodeToIcon;
import 'package:weather_app/utils/common.dart' show parseUnixTimestamp;
import 'package:weather_app/utils/ui.dart' show formatTemperature;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

final dateTimeFormat = DateFormat.yMMMd();
final sunsetTimeFormat = DateFormat.Hm();

class DetailsCard extends StatelessWidget {
  final ForecastResponse weather;

  const DetailsCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final currentWeather = weather.list[0];
    final icon = weatherCodeToIcon(currentWeather.weather[0].id);
    final temperature = formatTemperature(currentWeather.main.temp);
    final temperatureFeel = formatTemperature(currentWeather.main.feels_like);
    final countryName =
        countryCodesToNames[weather.city.country] ?? weather.city.country;
    final location = '$countryName, ${weather.city.name}';
    final dateTime = dateTimeFormat.format(DateTime.now());
    final sunsetTime =
        sunsetTimeFormat.format(parseUnixTimestamp(weather.city.sunset));

    return FrostedCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Today',
                  // style: theme.textTheme.titleMedium,
                  style: TextStyle(fontSize: 24),
                ),
                // TODO
                // SizedBox(width: 16),
                // Icon(Symbols.keyboard_arrow_down),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 80,
                ),
                const SizedBox(width: 8),
                Text(
                  temperature,
                  style: const TextStyle(fontSize: 72),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Snowy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(location),
            const SizedBox(height: 8),
            Text(dateTime),
            const SizedBox(height: 8),
            Text('Feels like $temperatureFeel | Sunset $sunsetTime'),
          ],
        ),
      ),
    );
  }
}
