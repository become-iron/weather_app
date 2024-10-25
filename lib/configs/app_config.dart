import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

class _WeatherServiceConfig {
  final String appId;

  const _WeatherServiceConfig({required this.appId});
}

class AppConfig {
  static final weatherService = _WeatherServiceConfig(
    appId: dotenv.get('WEATHER_SERVICE_APP_ID'),
  );
}
