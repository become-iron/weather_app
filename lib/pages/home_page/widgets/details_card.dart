import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/services/weather_service/models/weather_data.dart'
    show WeatherData;
import 'package:weather_app/utils/ui.dart' show formatTemperature;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

final fullDateFormat = DateFormat.yMMMd();
final relatedDateDefaultFormat = DateFormat.MMMMd();
final sunsetTimeFormat = DateFormat.Hm();

class DetailsCard extends StatelessWidget {
  final WeatherData weather;
  final int activeItemIndex;

  const DetailsCard({
    super.key,
    required this.weather,
    required this.activeItemIndex,
  });

  @override
  Widget build(BuildContext context) {
    final currentWeather = weather.data[activeItemIndex];

    final relatedDate = getRelatedDate(currentWeather.dateTime);
    final fullDate = fullDateFormat.format(currentWeather.dateTime);

    final temperature = formatTemperature(currentWeather.temperature);
    final temperatureFeel = formatTemperature(currentWeather.temperatureFeel);

    final location = '${weather.location.country}, ${weather.location.city}';

    final sunriseTime = sunsetTimeFormat.format(weather.location.sunriseTime);
    final sunsetTime = sunsetTimeFormat.format(weather.location.sunsetTime);

    return FrostedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 4),
            Text(fullDate, style: const TextStyle(fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  currentWeather.weatherCondition.icon,
                  size: 80,
                ),
                const SizedBox(width: 8),
                Text(
                  temperature,
                  style: const TextStyle(fontSize: 72),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currentWeather.weatherCondition.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Feels like $temperatureFeel',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(location),
            const SizedBox(height: 8),
            Text(
              'Sunrise $sunriseTime | Sunset $sunsetTime',
              style: const TextStyle(fontSize: 12),
            ),
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
