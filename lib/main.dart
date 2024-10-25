import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/pages/home_page.dart';

// const defaultTextColor = Color(0xFFC9E8E0);
const defaultTextColor = Color(0xFFD8F8EF);

void main() async {
  await dotenv.load(fileName: '.env.local');

  LicenseRegistry.addLicense(() async* {
    // add licenses for fonts in use
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

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
            // displayColor: Colors.white,
          ),
          cardTheme: const CardTheme(
            elevation: 0,
            color: Color(0xFF40666A),
          ),
          iconTheme: const IconThemeData(
            color: defaultTextColor,
          )),
      home: const HomePage(),
    );
  }
}
