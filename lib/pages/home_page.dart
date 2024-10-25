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
  }

  Future<void> fetchWeather() async {
    final position = await determinePosition();
    final weather_ = await WeatherService.getWeatherData(position);

    setState(() {
      weather = weather_;
    });
  }
}
