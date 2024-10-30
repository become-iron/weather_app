import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart' show Symbols;
import 'package:weather_app/utils/location.dart' show LocationException;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

class ExceptionMessage extends StatelessWidget {
  final LocationException exception;

  const ExceptionMessage({super.key, required this.exception});

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Symbols.error),
          const SizedBox(width: 12),
          Flexible(child: Text(exception.message)),
        ],
      ),
    ));
  }
}
