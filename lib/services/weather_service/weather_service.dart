import 'dart:convert' show jsonDecode;

import 'package:geolocator/geolocator.dart' show Position;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;
import 'package:weather_app/configs/app_config.dart' show appConfig;
import 'package:weather_app/utils/logger.dart' show logger;

import 'models/five_day_forecast.dart' show ForecastResponse;

// Docs:
// https://openweathermap.org/forecast5

// final responseDump = jsonDecode(
//     '{"cod":"200","message":0,"cnt":12,"list":[{"dt":1729846800,"main":{"temp":20.64,"feels_like":20.54,"temp_min":18.85,"temp_max":20.64,"pressure":1024,"sea_level":1024,"grnd_level":1018,"humidity":68,"temp_kf":1.79},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":2.49,"deg":349,"gust":3.97},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2024-10-25 09:00:00"},{"dt":1729857600,"main":{"temp":19.81,"feels_like":19.65,"temp_min":18.16,"temp_max":19.81,"pressure":1024,"sea_level":1024,"grnd_level":1018,"humidity":69,"temp_kf":1.65},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":1.92,"deg":353,"gust":2.84},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2024-10-25 12:00:00"},{"dt":1729868400,"main":{"temp":19.06,"feels_like":18.8,"temp_min":18.27,"temp_max":19.06,"pressure":1024,"sea_level":1024,"grnd_level":1018,"humidity":68,"temp_kf":0.79},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":1.44,"deg":14,"gust":1.96},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2024-10-25 15:00:00"},{"dt":1729879200,"main":{"temp":18.51,"feels_like":18.32,"temp_min":18.51,"temp_max":18.51,"pressure":1023,"sea_level":1023,"grnd_level":1016,"humidity":73,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":1.54,"deg":36,"gust":2.03},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2024-10-25 18:00:00"},{"dt":1729890000,"main":{"temp":18.66,"feels_like":18.57,"temp_min":18.66,"temp_max":18.66,"pressure":1022,"sea_level":1022,"grnd_level":1016,"humidity":76,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":1.57,"deg":41,"gust":2.07},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2024-10-25 21:00:00"},{"dt":1729900800,"main":{"temp":20.76,"feels_like":20.77,"temp_min":20.76,"temp_max":20.76,"pressure":1022,"sea_level":1022,"grnd_level":1016,"humidity":72,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":100},"wind":{"speed":1.54,"deg":69,"gust":2.36},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2024-10-26 00:00:00"},{"dt":1729911600,"main":{"temp":22.92,"feels_like":22.99,"temp_min":22.92,"temp_max":22.92,"pressure":1020,"sea_level":1020,"grnd_level":1014,"humidity":66,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":100},"wind":{"speed":1.74,"deg":70,"gust":2.82},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2024-10-26 03:00:00"},{"dt":1729922400,"main":{"temp":23.06,"feels_like":23.17,"temp_min":23.06,"temp_max":23.06,"pressure":1019,"sea_level":1019,"grnd_level":1013,"humidity":67,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":100},"wind":{"speed":1.27,"deg":53,"gust":2.36},"visibility":10000,"pop":0.01,"sys":{"pod":"d"},"dt_txt":"2024-10-26 06:00:00"},{"dt":1729933200,"main":{"temp":21.26,"feels_like":21.4,"temp_min":21.26,"temp_max":21.26,"pressure":1019,"sea_level":1019,"grnd_level":1013,"humidity":75,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":1.01,"deg":44,"gust":1.54},"visibility":10000,"pop":0.09,"sys":{"pod":"n"},"dt_txt":"2024-10-26 09:00:00"},{"dt":1729944000,"main":{"temp":20.48,"feels_like":20.65,"temp_min":20.48,"temp_max":20.48,"pressure":1019,"sea_level":1019,"grnd_level":1013,"humidity":79,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":1.23,"deg":54,"gust":1.67},"visibility":10000,"pop":0.05,"sys":{"pod":"n"},"dt_txt":"2024-10-26 12:00:00"},{"dt":1729954800,"main":{"temp":19.33,"feels_like":19.49,"temp_min":19.33,"temp_max":19.33,"pressure":1018,"sea_level":1018,"grnd_level":1012,"humidity":83,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":1.34,"deg":53,"gust":2.25},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2024-10-26 15:00:00"},{"dt":1729965600,"main":{"temp":18.15,"feels_like":18.29,"temp_min":18.15,"temp_max":18.15,"pressure":1017,"sea_level":1017,"grnd_level":1011,"humidity":87,"temp_kf":0},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"clouds":{"all":53},"wind":{"speed":1.67,"deg":55,"gust":2.29},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2024-10-26 18:00:00"}],"city":{"id":1852524,"name":"Shijōdōri","coord":{"lat":34.9866,"lon":135.7739},"country":"JP","population":0,"timezone":32400,"sunrise":1729804273,"sunset":1729843829}}');

class WeatherService {
  final client = http.Client();
  final weatherServiceHost = 'api.openweathermap.org';

  Future<void> init() async {
    final config = appConfig.weatherService;
    final storage = SharedPreferencesAsync();
    final String? formatVersion =
        await storage.getString(config.dataFormatVersionStorageKey);
    if (formatVersion != config.dataFormatVersion) {
      logger.d(
        'Remove cached weather data since it has different format version. '
        'Stored: $formatVersion. Current: ${config.dataFormatVersion}',
      );
      await storage.remove(config.storageKey);
    }
  }

  Future<ForecastResponse?> getCachedWeatherData() async {
    final config = appConfig.weatherService;
    final storage = SharedPreferencesAsync();
    final String? cachedData = await storage.getString(config.storageKey);
    return cachedData == null
        ? null
        : ForecastResponse.fromJson(jsonDecode(cachedData));
  }

  Future<ForecastResponse> getWeatherData({
    required Position position,
    int? count,
  }) async {
    // TODO: temp
    // return ForecastResponse.fromJson(responseDump);
    final http.Response response;
    try {
      response = await client.get(Uri.https(
        weatherServiceHost,
        '/data/2.5/forecast',
        {
          'lat': '${position.latitude}',
          'lon': '${position.longitude}',
          'appid': appConfig.weatherService.appId,
          'units': 'metric',
          if (count != null) 'cnt': '$count',
        },
      ));
    } finally {
      client.close();
    }

    final config = appConfig.weatherService;
    final storage = SharedPreferencesAsync();
    await storage.setString(config.storageKey, response.body);
    await storage.setString(
      config.dataFormatVersionStorageKey,
      config.dataFormatVersion,
    );

    return ForecastResponse.fromJson(jsonDecode(response.body));
  }
}
