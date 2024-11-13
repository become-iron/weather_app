import 'package:flutter/material.dart';

import '../types.dart';

final ThemeSet meowTheme = (
  id: 'meow',
  name: 'Meow',
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink,
    ),
  ),
  imageUri: 'images/background.jpg',
);
