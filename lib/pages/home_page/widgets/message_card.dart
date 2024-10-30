import 'package:flutter/material.dart';
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

class MessageCard extends StatelessWidget {
  final Widget icon;
  final String message;

  const MessageCard({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Flexible(child: Text(message)),
        ],
      ),
    ));
  }
}
