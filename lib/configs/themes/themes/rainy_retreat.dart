import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

import '../types.dart';

const defaultTextColor = Color(0xFFD8F8EF);
const baseColor = Color(0xFF40666A);
final surfaceColor = baseColor.withOpacity(0.8);

ThemeSet rainyRetreatTheme = (
  id: 'rainy_retreat',
  name: 'Rainy Retreat',
  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: baseColor,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: defaultTextColor,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: surfaceColor,
    ),
    iconTheme: const IconThemeData(
      color: defaultTextColor,
    ),
    appBarTheme: AppBarTheme(
      color: surfaceColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: surfaceColor,
      foregroundColor: defaultTextColor,
    ),
    dividerTheme: DividerThemeData(
      color: defaultTextColor.withOpacity(0.5),
    ),
  ),
  imageUri: 'images/background.jpg',
);
