import 'package:flutter/material.dart';
import 'package:weather_app/widgets/frosted_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
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
