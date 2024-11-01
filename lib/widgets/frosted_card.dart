// import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FrostedCard extends StatelessWidget {
  final Widget child;

  const FrostedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // based on: https://www.youtube.com/watch?app=desktop&v=vIjyphym6Ck
    return Card(
      child: child,
      // disable blur since it works incorrectly
      // with SingleChildScrollView and ListView
      // https://stackoverflow.com/a/66688501/4729582
      // child: ClipRRect(
      //   borderRadius: BorderRadius.circular(12),
      //   child: BackdropFilter(
      //     filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      //     child: child,
      //   ),
      // ),
    );
  }
}
