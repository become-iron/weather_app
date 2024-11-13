import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../configs/themes/themes.dart' show defaultThemeId, themes;
import '../configs/themes/types.dart' show ThemeSet;

part 'theme.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<ThemeSet> build() async {
    return themes[defaultThemeId]!;
  }

  Future<void> setTheme(String themeId) async {
    state = AsyncData(themes[themeId]!);
  }
}
