import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;

import '../configs/app_config.dart' show appConfig;
import '../configs/themes/themes.dart' show defaultThemeId, themes;
import '../configs/themes/types.dart' show ThemeSet;

part 'theme.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<ThemeSet> build() async {
    final storage = SharedPreferencesAsync();
    var themeId = await storage.getString(appConfig.themeStorageKey);

    // if no saved theme or non-existing theme id
    if (themeId == null || !themes.containsKey(themeId)) {
      themeId = defaultThemeId;
      await storage.setString(appConfig.themeStorageKey, themeId);
    }

    return themes[themeId]!;
  }

  Future<void> setTheme(String themeId) async {
    final storage = SharedPreferencesAsync();
    await storage.setString(appConfig.themeStorageKey, themeId);

    state = AsyncData(themes[themeId]!);
  }
}
