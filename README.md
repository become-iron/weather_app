# weather_app

A simple weather application.

## Development

Design: [Weather App | Template](https://www.figma.com/community/file/1177627357046864157).

### Tools

* Flutter 3.24.3
* Dart 3.5.3
* Java: Oracle OpenJDK 23.0.1
* Gradle 8.10.2

#### Libraries

* `material_symbols_icons` - Google Material Symbols Icons.
* `google_fonts` - Google Fonts.
* `geolocator` - geolocation plugin.
* `http` - HTTP requests.
* `flutter_dotenv` - load configuration from a .env file.
* `freezed` with `json_serializable` - immutable serializable data models.
* `shared_preferences` - persistent storage for simple data.
* `logger` - logger.

#### Services

* [OpenWeatherMap API](https://openweathermap.org/api) - weather APIs.

### Commands

* `flutter analyze` - analyze the project's Dart code.
* `dart fix --apply` - apply automated fixes to Dart source code.
* `dart run build_runner build` - run build scripts (e.g., generate freezed models).
* `flutter test` - run Flutter unit tests.
* `flutter build apk --split-per-abi` - build APKs.

### Environment variables

* `WEATHER_SERVICE_APP_ID` - an application id to use OpenWeatherMap API (not safe in terms of
  security).

### Initial setup

1. Create a file with environment variables and fill it with the correct values.

    ```shell
    cp .env.example .env.local
    ```

2. Generate auxiliary files.

    ```shell
    dart run build_runner build
    ```

#### Android Studio setup (optional)

* Hide generated files: https://stackoverflow.com/a/69728616/4729582.
* Add a live template to generate freezed models:

    ```dart
    @freezed
    class $NAME$ with _$$$NAME$ {
      const factory $NAME$({
        $END$,
      }) = _$NAME$;

      factory $NAME$.fromJson(Map<String, Object?> json) => _$$$NAME$FromJson(json);
    }
    ```

## TODO

* Use skeletons?
* Make layout responsive
* Add ability to change theme
* Update icon
* Handle requests errors
* Write tests
* currently, the API request doesn't return the current weather, so workaround it someway
