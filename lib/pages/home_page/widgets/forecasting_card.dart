import 'package:collection/collection.dart'
    show IterableExtension, IterableIterableExtension;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/services/weather_service/models/weather_data.dart'
    show WeatherData;
import 'package:weather_app/utils/ui.dart' show formatTemperature;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

// TODO: do not hardcode these values, but rather make the layout responsive
const rowsNumber = 3;
const columnsNumbers = 4;
const itemsNumber = rowsNumber * columnsNumbers;

final dateTimeDisplayFormat = DateFormat.Hm();

typedef TileData = ({String date, String temperature, IconData icon});

class ForecastingCard extends StatelessWidget {
  final WeatherData weather;
  final int activeItemIndex;
  final void Function(int index) onActiveItemChange;

  const ForecastingCard({
    super.key,
    required this.weather,
    required this.activeItemIndex,
    required this.onActiveItemChange,
  });

  @override
  Widget build(BuildContext context) {
    final chunks = getGridItems().slices(columnsNumbers);

    return FrostedCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            for (final (i, chunk) in chunks.indexed)
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final (j, data) in chunk.indexed)
                      WeatherTile(
                        data: data,
                        active: activeItemIndex == i * columnsNumbers + j,
                        onActivate: () {
                          onActiveItemChange(i * columnsNumbers + j);
                        },
                      ),
                  ],
                ),
                if (i < chunks.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Divider(color: Colors.white.withOpacity(0.5)),
                  ),
              ]
          ].flattened.toList(),
        ),
      ),
    );
  }

  Iterable<TileData> getGridItems() sync* {
    for (final item in weather.data.sublist(0, itemsNumber)) {
      yield (
        date: dateTimeDisplayFormat.format(item.dateTime),
        temperature: formatTemperature(item.temperature),
        icon: item.weatherCondition.icon,
      );
    }
  }
}

class WeatherTile extends StatelessWidget {
  final TileData data;
  final bool active;
  final void Function() onActivate;

  const WeatherTile({
    super.key,
    required this.data,
    required this.active,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);

    return ClipRRect(
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onActivate,
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: active ? Colors.white.withOpacity(0.1) : null,
          child: Column(
            children: [
              Text(data.date),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(data.icon),
                  const SizedBox(width: 4),
                  Text(data.temperature),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
