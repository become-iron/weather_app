import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FrostedCard extends StatelessWidget {
  final Widget child;

  const FrostedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // based on: https://www.youtube.com/watch?app=desktop&v=vIjyphym6Ck
    return Card(
      color: theme.cardTheme.color!.withOpacity(0.8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: child,
        ),
      ),
    );
  }
}
