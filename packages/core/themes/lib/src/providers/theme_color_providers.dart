import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/theme_color_scheme.dart' as models;
import '../models/app_color_scheme.dart';
import 'theme_providers.dart';

part 'theme_color_providers.g.dart';

/// Currently selected theme color type.
@riverpod
class ThemeColorType extends _$ThemeColorType {
  @override
  models.ThemeColorType build() {
    return models.ThemeColorType.blue;
  }

  void setThemeColor(models.ThemeColorType type) {
    state = type;
  }
}

/// Theme color scheme.
@riverpod
models.ThemeColorScheme themeColorScheme(Ref ref) {
  final themeType = ref.watch(themeColorTypeProvider);
  final brightness = ref.watch(platformBrightnessProvider);

  return models.ThemeColorScheme.create(themeType, brightness);
}

/// Based on the current theme, system brightness settings, and theme color,
/// a Provider that obtains the AppColorScheme to be actually applied.
@riverpod
AppColorScheme effectiveColorSchemeWithTheme(Ref ref) {
  final themeData = ref.watch(activeThemeProvider);
  final platformBrightness = ref.watch(platformBrightnessProvider);
  final themeColorType = ref.watch(themeColorTypeProvider);

  // Get base ColorScheme
  final effectiveColorScheme = themeData.getEffectiveAppColorScheme(
    platformBrightness,
  );

  // Create a new ColorScheme with theme colors integrated
  return AppColorScheme.fromColorScheme(
    effectiveColorScheme.toColorScheme(),
    themeType: themeColorType,
  );
}
