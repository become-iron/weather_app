import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

import '../types.dart';

const defaultTextColor = Color(0xFFFFFFFF);
const baseColor = Color(0xFF91B4C6);
final surfaceColor = baseColor.withOpacity(0.8);

final ThemeSet frostedPathsTheme = (
  id: 'frosted_paths',
  name: 'Frosted Paths',
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
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: defaultTextColor.withOpacity(0.9)),
    ),
  ),
  imageUri: 'images/frosted_paths.jpg',
);