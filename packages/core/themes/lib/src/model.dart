// Imports
import 'models/app_color_scheme.dart';
import 'models/app_theme_data.dart';
import 'presets.dart';

// Export model classes
export 'models/app_color_scheme.dart';
export 'models/app_theme_data.dart';
export 'models/app_typography_config.dart';
export 'models/app_font_config.dart';
export 'models/app_accessibility_config.dart';
export 'models/theme_color_scheme.dart';
export 'models/color_structure.dart';

// Alias for old class name
typedef AppColorConfig = AppColorScheme;
typedef ThemeConfig = AppThemeData;

// Alias for old class name（互換性のため）
class ThemePresets {
  /// Theme that follows system settings
  static final AppThemeData system = AppThemePresets.system;

  /// Light mode theme
  static final AppThemeData light = AppThemePresets.light;

  /// Dark mode theme
  static final AppThemeData dark = AppThemePresets.dark;

  /// List of all preset themes
  static final List<AppThemeData> all = AppThemePresets.all;
}
