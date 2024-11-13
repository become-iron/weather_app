import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/theme.dart' show themeNotifierProvider;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

import '../configs/themes/themes.dart' show themes;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSet = ref.watch(themeNotifierProvider).value;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        decoration: themeSet == null
            ? null
            : BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(themeSet.imageUri),
                  fit: BoxFit.cover,
                ),
              ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FrostedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownMenu(
                          expandedInsets: EdgeInsets.zero,
                          initialSelection: themeSet?.id,
                          label: const Text('Theme'),
                          onSelected: (String? themeId) {
                            ref
                                .read(themeNotifierProvider.notifier)
                                .setTheme(themeId!);
                          },
                          dropdownMenuEntries: themes.values
                              .map((theme) => DropdownMenuEntry(
                                    value: theme.id,
                                    label: theme.name,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
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
