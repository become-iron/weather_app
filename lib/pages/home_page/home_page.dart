import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:material_symbols_icons/symbols.dart' show Symbols;
import 'package:weather_app/services/weather_service/models/five_day_forecast.dart'
    show ForecastResponse;
import 'package:weather_app/services/weather_service/weather_service.dart'
    show WeatherService;
import 'package:weather_app/utils/location.dart'
    show LocationException, checkLocationPermissions, determinePosition;

import 'widgets/details_card.dart' show DetailsCard;
import 'widgets/forecasting_card.dart' show ForecastingCard, itemsNumber;
import 'widgets/message_card.dart' show MessageCard;

typedef MessageData = ({Widget icon, String message});

class HomePage extends StatefulWidget {
  final WeatherService weatherService;

  const HomePage({super.key, required this.weatherService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MessageData? message;
  Position? position;
  ForecastResponse? weather;
  int activeWeatherItemIndex = 0;

  @override
  void initState() {
    super.initState();
    initStateAsync().catchError((e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $e'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      // set physics to show refresh indicator
      // even if content is less than viewport
      // https://api.flutter.dev/flutter/material/RefreshIndicator-class.html#refresh-indicator-does-not-show-up
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (message != null)
            MessageCard(
              icon: message!.icon,
              message: message!.message,
            ),
          // TODO: use skeletons
          if (weather != null)
            DetailsCard(
              weather: weather!,
              activeItemIndex: activeWeatherItemIndex,
            ),
          const SizedBox(height: 24),
          if (weather != null)
            ForecastingCard(
              weather: weather!,
              activeItemIndex: activeWeatherItemIndex,
              onActiveItemChange: (index) {
                setState(() {
                  activeWeatherItemIndex = index;
                });
              },
            ),
        ],
      ),
    );

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
        child:
            // disable refresh gesture if there is no position
            position == null
                ? content
                : RefreshIndicator(
                    onRefresh: fetchWeather,
                    child: content,
                  ),
      ),
    );
  }

  Future<void> initStateAsync() async {
    final weather_ = await widget.weatherService.getCachedWeatherData();
    if (weather_ != null) {
      setState(() {
        weather = weather_;
      });
    }

    try {
      await checkLocationPermissions();
    } on LocationException catch (e) {
      setState(() {
        message = (
          icon: const Icon(Symbols.error),
          message: e.message,
        );
      });
      return;
    }

    position = await handleLongTask(
      determinePosition(),
      const (
        icon: Icon(Symbols.pending),
        message: 'We are trying to determine your location. '
            'This is taking longer than usual.',
      ),
    );

    await handleLongTask(
      fetchWeather(),
      const (
        icon: Icon(Symbols.pending),
        message: 'We are trying to request the weather. '
            'This is taking longer than usual.',
      ),
    );
  }

  Future<void> fetchWeather() async {
    if (position == null) {
      return;
    }

    final weather_ = await widget.weatherService.getWeatherData(
      position: position!,
      // TODO: temp
      count: itemsNumber,
    );

    setState(() {
      weather = weather_;
      activeWeatherItemIndex = 0;
    });
  }

  /// Executes a long-running task and updates the UI with a message if it
  /// exceeds a specified duration.
  ///
  /// [future] the long-running task to execute.
  /// [message_] the message data to display if the task takes too long.
  /// [waitFor] specifies the delay in seconds before displaying
  /// the message.
  ///
  /// Returns the result of the [future] once completed.
  ///
  /// This function waits for the specified [waitFor] duration. If the task is
  /// still running after this delay, it displays the message on the UI. Once
  /// the task completes, it removes the message.
  Future<T> handleLongTask<T>(
    Future<T> future,
    MessageData message_, {
    int waitFor = 2,
  }) async {
    final symbol = UniqueKey();
    final result = await Future.any([
      future,
      Future.delayed(
        Duration(seconds: waitFor),
        () => symbol,
      ),
    ]);
    if (result == symbol) {
      setState(() {
        message = message_;
      });
    }

    try {
      return await future;
    } finally {
      setState(() {
        message = null;
      });
    }
  }
}
