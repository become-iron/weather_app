import 'package:flutter/foundation.dart'
    show LicenseRegistry, LicenseEntryWithLineBreaks;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerState, ConsumerStatefulWidget, ProviderScope;
import 'package:weather_app/providers/theme.dart' show themeNotifierProvider;

import 'pages/home_page/home_page.dart' show HomePage;

void main() async {
  await dotenv.load(fileName: '.env.local');

  LicenseRegistry.addLicense(() async* {
    // add licenses for fonts in use
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const ProviderScope(child: WeatherApp()));
}

class WeatherApp extends ConsumerStatefulWidget {
  const WeatherApp({super.key});

  @override
  ConsumerState<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends ConsumerState<WeatherApp> {
  @override
  Widget build(BuildContext context) {
    final themeSet = ref.watch(themeNotifierProvider).value;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: themeSet?.theme,
      home: const HomePage(),
    );
  }
}
