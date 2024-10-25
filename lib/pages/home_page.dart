import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart';
import 'package:weather_app/services/weather_service/weather_service.dart'
    show WeatherService;
import 'package:weather_app/utils/common.dart' show determinePosition;
import 'package:weather_app/widgets/details_card.dart' show DetailsCard;
import 'package:weather_app/widgets/forecasting_card.dart' show ForecastingCard;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    fetchWeather();

    //   determinePosition().then((position) async {
    //     print('Position: $position');
    //     print(appConfig.weatherService.appId);
    //     final data = await WeatherService.getWeatherData(position);
    //     print(data.list[0].main);
    //     print(data.list[0].weather);
    //
    //     for (var item in data.list.sublist(0, 10)) {
    //       print(item.dt_txt);
    //       print(DateTime.parse(item.dt_txt));
    //       print(DateFormat.yMMMd().format(DateTime.parse(item.dt_txt)));
    //     }
    //   });
  }

  ForecastResponse? weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   toolbarHeight: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          // consider the height of system status bar
          16 + MediaQuery.viewPaddingOf(context).top,
          16,
          16,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DetailsCard(),
              const SizedBox(height: 24),
              if (weather != null) ForecastingCard(weather: weather!),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   // appBar: AppBar(
    //   //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //   //   title: const Text('Weather App'),
    //   //   centerTitle: true,
    //   // ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headlineMedium,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ),
    // );
  }

  Future<void> fetchWeather() async {
    final position = await determinePosition();

    // print('Position: $position');
    // print(appConfig.weatherService.appId);
    final data = await WeatherService.getWeatherData(position);
    // print(data.list[0].main);
    // print(data.list[0].weather);

    // List<WeatherData> processedWeatherData = [];

    // for (final item in data.list.sublist(0, 12)) {
    //   final date = DateTime.fromMillisecondsSinceEpoch(
    //     item.dt * 1000,
    //     isUtc: true,
    //   ).toLocal();
    //   print(date);
    //   // print(item.dt_txt);
    //   // print(DateTime.fromMillisecondsSinceEpoch(item.dt * 1000, isUtc: true));
    //   // print(DateFormat('yyyy-MM-dd HH:mm:ss')
    //   //     .parse(item.dt_txt, true)
    //   //     .toLocal());
    //   // print(DateTime.parse(item.dt_txt));
    //   // print(DateTime.parse(item.dt_txt).toLocal());
    //   // print(DateFormat.Hm().format(DateTime.parse(item.dt_txt).toLocal()));
    //   processedWeatherData.add(WeatherData(
    //     date: DateFormat.Hm().format(date),
    //     temperature: item.main.temp.round(),
    //     icon: const Icon(Symbols.cloudy),
    //   ));
    // }

    setState(() {
      weather = data;
    });
  }
}
