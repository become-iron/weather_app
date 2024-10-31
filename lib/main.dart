import 'package:flutter/foundation.dart'
    show LicenseRegistry, LicenseEntryWithLineBreaks;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

import 'pages/home_page/home_page.dart' show HomePage;

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
