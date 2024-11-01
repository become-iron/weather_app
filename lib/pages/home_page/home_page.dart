import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:material_symbols_icons/symbols.dart' show Symbols;
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/services/weather_service/models/weather_data.dart'
    show WeatherData;
import 'package:weather_app/services/weather_service/weather_service.dart'
    show WeatherService;
import 'package:weather_app/utils/location.dart'
    show LocationException, checkLocationPermissions, determinePosition;
import 'package:weather_app/utils/logger.dart' show logger;

import 'widgets/details_card.dart' show DetailsCard;
import 'widgets/forecasting_card.dart' show ForecastingCard, itemsNumber;
import 'widgets/message_card.dart' show MessageCard;

typedef MessageData = ({Widget icon, String message});

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MessageData? message;
  Position? position;
  WeatherData? weather;
  int activeWeatherItemIndex = 0;

  @override
  void initState() {
    super.initState();
    initStateAsync().catchError((e) {
      logger.e('Error occurred during state initialization', error: e);
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
    final theme = Theme.of(context);

    final List<Widget> children = [];

    if (message != null) {
      children.addAll([
        MessageCard(
          icon: message!.icon,
          message: message!.message,
        ),
        const SizedBox(height: 24),
      ]);
    }

    if (weather != null) {
      children.addAll([
        DetailsCard(
          weather: weather!,
          activeItemIndex: activeWeatherItemIndex,
        ),
        const SizedBox(height: 24),
        ForecastingCard(
          weather: weather!,
          activeItemIndex: activeWeatherItemIndex,
          onActiveItemChange: (index) {
            setState(() {
              activeWeatherItemIndex = index;
            });
          },
        ),
      ]);
    }

    final content = SingleChildScrollView(
      // set physics to show refresh indicator
      // even if content is less than viewport
      // https://api.flutter.dev/flutter/material/RefreshIndicator-class.html#refresh-indicator-does-not-show-up
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    return Scaffold(
      body: Container(
        // to get rid of the area with default background
        // at the bottom of screen when there a little number of items
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                // disable refresh gesture if there is no position
                position == null
                    ? content
                    // TODO: restrict refresh rate
                    : RefreshIndicator(
                        color: theme.colorScheme.inversePrimary,
                        backgroundColor: theme.colorScheme.inverseSurface,
                        // TODO: display message on error
                        onRefresh: fetchWeather,
                        child: content,
                      ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
        },
        child: const Icon(Symbols.settings),
      ),
    );
  }

  Future<void> initStateAsync() async {
    final weather_ = await WeatherService.getCachedWeatherData();
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
        icon: PendingIcon(),
        message: 'We are trying to determine your location. '
            'This is taking longer than usual.',
      ),
    );

    await handleLongTask(
      fetchWeather(),
      const (
        icon: PendingIcon(),
        message: 'We are trying to request the weather. '
            'This is taking longer than usual.',
      ),
    );
  }

  Future<void> fetchWeather() async {
    if (position == null) {
      return;
    }

    final weather_ = await WeatherService.getWeatherData(
      position: position!,
      // TODO: temp
      // detract 1 to consider the current weather as well
      count: itemsNumber - 1,
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

class PendingIcon extends StatelessWidget {
  const PendingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 16,
      height: 16,
      child: Center(
        child: CircularProgressIndicator(
          color: theme.textTheme.bodyMedium?.color,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
