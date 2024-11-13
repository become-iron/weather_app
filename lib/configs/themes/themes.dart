import 'themes/amber_woods.dart' show amberWoodsTheme;
import 'themes/frosted_paths.dart' show frostedPathsTheme;
import 'themes/rainy_retreat.dart' show rainyRetreatTheme;
import 'types.dart' show ThemeSet;

final defaultThemeId = rainyRetreatTheme.id;

final List<ThemeSet> _themes = [
  rainyRetreatTheme,
  frostedPathsTheme,
  amberWoodsTheme,
];

final Map<String, ThemeSet> themes = {for (final t in _themes) t.id: t};
