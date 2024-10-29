import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/services/weather_service/configs.dart'
    show countryCodesToNames;
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart'
    show ForecastResponse;
import 'package:weather_app/services/weather_service/utils.dart'
    show weatherCodeToIcon;
import 'package:weather_app/utils/common.dart' show parseUnixTimestamp;
import 'package:weather_app/utils/ui.dart' show formatTemperature;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

final fullDateFormat = DateFormat.yMMMd();
final relatedDateDefaultFormat = DateFormat.MMMMd();
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

    final rawDateTime = parseUnixTimestamp(currentWeather.dt);
    final fullDate = fullDateFormat.format(rawDateTime);
    final relatedDate = getRelatedDate(rawDateTime);

    final sunsetTime =
        sunsetTimeFormat.format(parseUnixTimestamp(weather.city.sunset));

    return FrostedCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  relatedDate,
                  style: const TextStyle(fontSize: 24),
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
            Text(fullDate),
            const SizedBox(height: 8),
            Text('Feels like $temperatureFeel | Sunset $sunsetTime'),
          ],
        ),
      ),
    );
  }

  // based on: https://stackoverflow.com/a/74345643/4729582
  String getRelatedDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    String result;
    final checkDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (checkDate == today) {
      result = 'Today';
    } else if (checkDate == yesterday) {
      result = 'Yesterday';
    } else if (checkDate == tomorrow) {
      result = 'Tomorrow';
    } else {
      result = relatedDateDefaultFormat.format(dateTime);
    }
    return result;
  }
}
