import 'package:collection/collection.dart'
    show IterableExtension, IterableIterableExtension;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_symbols_icons/symbols.dart' show Symbols;
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart'
    show ForecastResponse;
import 'package:weather_app/widgets/frosted.dart' show FrostedCard;

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
    final List<WeatherData> processedWeatherData = [];

    for (final item in weather.list.sublist(0, 12)) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        item.dt * 1000,
        isUtc: true,
      ).toLocal();
      processedWeatherData.add(WeatherData(
        date: DateFormat.Hm().format(date),
        temperature: item.main.temp.round(),
        icon: const Icon(Symbols.cloudy),
      ));
    }

    final chunks = processedWeatherData.slices(4).toList();

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
}
