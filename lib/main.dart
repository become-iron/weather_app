import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/pages/home_page/home_page.dart';
import 'package:weather_app/services/weather_service/weather_service.dart'
    show WeatherService;

const defaultTextColor = Color(0xFFD8F8EF);

void main() async {
  await dotenv.load(fileName: '.env.local');

  final weatherService = WeatherService();
  await weatherService.init();

  LicenseRegistry.addLicense(() async* {
    // add licenses for fonts in use
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(WeatherApp(weatherService: weatherService));
}

class WeatherApp extends StatelessWidget {
  final WeatherService weatherService;

  const WeatherApp({super.key, required this.weatherService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: defaultTextColor,
          ),
          cardTheme: const CardTheme(
            elevation: 0,
            color: Color(0xFF40666A),
          ),
          iconTheme: const IconThemeData(
            color: defaultTextColor,
          )),
      home: HomePage(weatherService: weatherService),
    );
  }
}
