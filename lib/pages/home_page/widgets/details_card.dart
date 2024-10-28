import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart' show Symbols;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FrostedCard(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Today',
                  // style: theme.textTheme.titleMedium,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 16),
                Icon(Symbols.keyboard_arrow_down),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Symbols.cloudy,
                  size: 80,
                ),
                SizedBox(width: 8),
                Text(
                  '-8°',
                  style: TextStyle(fontSize: 72),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Snowy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text('California, Los Angeles'),
            SizedBox(height: 8),
            Text('21 Oct, 2019'),
            SizedBox(height: 8),
            Text('Feels like -13° | Sunset 18:20'),
          ],
        ),
      ),
    );
  }
}
