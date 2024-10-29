import 'package:collection/collection.dart'
    show IterableExtension, IterableIterableExtension;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart'
    show ForecastResponse;
import 'package:weather_app/services/weather_service/utils.dart'
    show weatherCodeToIcon;
import 'package:weather_app/utils/common.dart' show parseUnixTimestamp;
import 'package:weather_app/utils/ui.dart' show formatTemperature;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

// TODO: do not hardcode these values, but rather make the layout responsive
const rowsNumber = 3;
const columnsNumbers = 4;
const itemsNumber = rowsNumber * columnsNumbers;

final dateTimeDisplayFormat = DateFormat.Hm();

class WeatherData {
  final String date;
  final String temperature;
  final IconData icon;

  const WeatherData({
    required this.date,
    required this.temperature,
    required this.icon,
  });
}

class ForecastingCard extends StatelessWidget {
  final ForecastResponse weather;

  const ForecastingCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final chunks = getGridItems().slices(columnsNumbers);

    return FrostedCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            for (final (i, chunk) in chunks.indexed)
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [for (var data in chunk) WeatherTile(data: data)],
                ),
                if (i < chunks.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Divider(color: Colors.white.withOpacity(0.5)),
                  ),
              ]
          ].flattened.toList(),
        ),
      ),
    );
  }

  Iterable<WeatherData> getGridItems() sync* {
    for (final item in weather.list.sublist(0, itemsNumber)) {
      yield WeatherData(
        date: dateTimeDisplayFormat.format(parseUnixTimestamp(item.dt)),
        temperature: formatTemperature(item.main.temp),
        icon: weatherCodeToIcon(item.weather[0].id),
      );
    }
  }
}

class WeatherTile extends StatelessWidget {
  final WeatherData data;

  const WeatherTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(data.date),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(data.icon),
            const SizedBox(width: 4),
            Text(data.temperature)
          ],
        ),
      ],
    );
  }
}
