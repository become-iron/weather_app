import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/theme.dart' show themeNotifierProvider;
import 'package:weather_app/widgets/frosted_card.dart' show FrostedCard;

import '../configs/themes/themes.dart' show themes;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider).value;

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
                        // const Text('Themes'),
                        // const SizedBox(height: 12),
                        DropdownMenu(
                          expandedInsets: EdgeInsets.zero,
                          initialSelection: theme?.id,
                          // requestFocusOnTap: true,
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
                                    // enabled: color.label != 'Grey',
                                    // style: MenuItemButton.styleFrom(
                                    //   foregroundColor: color.color,
                                    // ),
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
