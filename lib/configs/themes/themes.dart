import 'themes/meow.dart' show meowTheme;
import 'themes/rainy_retreat.dart' show rainyRetreatTheme;
import 'types.dart' show ThemeSet;

final defaultThemeId = rainyRetreatTheme.id;

final List<ThemeSet> _themes = [
  rainyRetreatTheme,
  meowTheme,
];

final Map<String, ThemeSet> themes = {for (final t in _themes) t.id: t};
