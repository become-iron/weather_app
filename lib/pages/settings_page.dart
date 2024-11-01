import 'package:flutter/material.dart';
import 'package:weather_app/widgets/frosted_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: theme.cardTheme.color!.withOpacity(0.8),
        leading: const BackButton(color: Colors.white),
        title: Text(
          'Settings',
          style: TextStyle(
            // fontWeight: FontWeight.w800,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FrostedCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Setting 1'),
                  ),
                ),
                FrostedCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Setting 2'),
                  ),
                ),
                FrostedCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Setting 3'),
                  ),
                ),
                FrostedCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Setting 4'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
