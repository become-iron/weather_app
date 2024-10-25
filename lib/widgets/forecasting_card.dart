import 'package:collection/collection.dart'
    show IterableExtension, IterableIterableExtension;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart';
import 'package:weather_app/widgets/frosted.dart' show FrostedCard;

// class WeatherData {
//   final String date;
//   final int temperature;
//   final Icon icon;
//
//   const WeatherData({
//     required this.date,
//     required this.temperature,
//     required this.icon,
//   });
// }

class ForecastingCard extends StatelessWidget {
  // static const List<WeatherData> weatherData = [
  //   WeatherData(date: 'Now', temperature: -8, icon: Icon(Symbols.cloudy)),
  //   WeatherData(date: '2 AM', temperature: -8, icon: Icon(Symbols.rainy)),
  //   WeatherData(date: '3 AM', temperature: -8, icon: Icon(Symbols.cloudy)),
  //   WeatherData(date: '4 AM', temperature: -8, icon: Icon(Symbols.cloudy)),
  //   WeatherData(date: '5 AM', temperature: -8, icon: Icon(Symbols.cloudy)),
  //   WeatherData(date: '6 AM', temperature: -8, icon: Icon(Symbols.cloudy)),
  //   WeatherData(date: '7 AM', temperature: -8, icon: Icon(Symbols.sunny)),
  //   WeatherData(date: '8 AM', temperature: -8, icon: Icon(Symbols.cloudy)),
  //   WeatherData(date: '9 AM', temperature: -8, icon: Icon(Symbols.cloudy)),
  //   WeatherData(
  //       date: '10 AM', temperature: -8, icon: Icon(Symbols.thunderstorm)),
  // ];

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
      print(date);
      // print(item.dt_txt);
      // print(DateTime.fromMillisecondsSinceEpoch(item.dt * 1000, isUtc: true));
      // print(DateFormat('yyyy-MM-dd HH:mm:ss')
      //     .parse(item.dt_txt, true)
      //     .toLocal());
      // print(DateTime.parse(item.dt_txt));
      // print(DateTime.parse(item.dt_txt).toLocal());
      // print(DateFormat.Hm().format(DateTime.parse(item.dt_txt).toLocal()));
      processedWeatherData.add(WeatherData(
        date: DateFormat.Hm().format(date),
        temperature: item.main.temp.round(),
        icon: const Icon(Symbols.cloudy),
      ));
    }

    final chunks = processedWeatherData.slices(4).toList();

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(12),
    //   child: BackdropFilter(
    //     filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //     child: ,
    //   ),
    // );

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
