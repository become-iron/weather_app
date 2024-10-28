import 'package:collection/collection.dart'
    show IterableExtension, IterableIterableExtension;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_symbols_icons/symbols.dart' show Symbols;
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart'
    show ForecastResponse;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

const rowsNumber = 3;
const columnsNumbers = 4;
const itemsNumber = rowsNumber * columnsNumbers;
final dateTimeDisplayFormat = DateFormat.Hm();

class WeatherData {
  final String date;
  final int temperature;
  final Icon icon;

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
                  children: [
                    for (var data in chunk)
                      Column(
                        children: [
                          Text(data.date),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              data.icon,
                              const SizedBox(width: 4),
                              Text('${data.temperature}')
                            ],
                          ),
                        ],
                      ),
                  ],
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
        date: formatDateTime(item.dt),
        temperature: item.main.temp.round(),
        icon: const Icon(Symbols.cloudy), // TODO
      );
    }
  }

  /// Formats a given UNIX UTC-based timestamp
  /// to a local time string in "HH:mm" format.
  ///
  /// - [dateTime]: An integer representing the UNIX timestamp (in seconds).
  String formatDateTime(int dateTime) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      dateTime * 1000,
      isUtc: true,
    ).toLocal();
    return dateTimeDisplayFormat.format(date);
  }
}
