import 'package:flutter/material.dart';

import 'themes/meow.dart' show meowTheme;
import 'themes/rainy_retreat.dart' show rainyRetreatTheme;
import 'types.dart' show ThemeSet;

const defaultTextColor = Color(0xFFD8F8EF);
const baseColor = Color(0xFF40666A);
final surfaceColor = baseColor.withOpacity(0.8);

final defaultThemeId = rainyRetreatTheme.id;

Map<String, ThemeSet> themes = {
  rainyRetreatTheme.id: rainyRetreatTheme,
  meowTheme.id: meowTheme,
};
