import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart'
    show ForecastResponse;
import 'package:weather_app/services/weather_service/weather_service.dart'
    show WeatherService;
import 'package:weather_app/utils/location.dart'
    show LocationException, determinePosition;

import 'widgets/details_card.dart' show DetailsCard;
import 'widgets/exception_message.dart' show ExceptionMessage;
import 'widgets/forecasting_card.dart' show ForecastingCard, itemsNumber;

class HomePage extends StatefulWidget {
  final WeatherService weatherService;

  const HomePage({super.key, required this.weatherService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ForecastResponse? weather;
  LocationException? exception;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  Future<void> initStateAsync() async {
    await fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // TODO: make it scrollable
      body: Container(
        // to get rid of the white area at the bottom of screen
        // when there a little number of items
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(
          16,
          // consider the height of system status bar
          16 + MediaQuery.viewPaddingOf(context).top,
          16,
          16,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          // set to disable background color change on debouncing
          // https://stackoverflow.com/a/66688501/4729582
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (exception != null) ExceptionMessage(exception: exception!),
              // TODO: use skeletons
              if (weather != null) DetailsCard(weather: weather!),
              const SizedBox(height: 24),
              if (weather != null) ForecastingCard(weather: weather!),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchWeather() async {
    ForecastResponse? weather_ =
        await widget.weatherService.getCachedWeatherData();
    if (weather_ != null) {
      setState(() {
        weather = weather_;
      });
    }

    final Position? position;
    try {
      position = await determinePosition();
    } on LocationException catch (e) {
      setState(() {
        exception = e;
      });
      return;
    }

    weather_ = await widget.weatherService.getWeatherData(
      position: position,
      // TODO: temp
      count: itemsNumber,
    );

    setState(() {
      weather = weather_;
    });
  }
}
