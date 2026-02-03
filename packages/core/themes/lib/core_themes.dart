library;

// Model classes
export 'src/models/app_color_scheme.dart';
export 'src/models/app_theme_data.dart';
export 'src/models/app_typography_config.dart';
export 'src/models/app_font_config.dart';
export 'src/models/app_accessibility_config.dart';

// Export old classes for compatibility
export 'src/models/app_font_config.dart' show FontConfig;

// Presets and utilities
export 'src/presets.dart';
// src/capsules.dart removed - migrated to theme_providers.dart
export 'src/providers/theme_providers.dart';
export 'src/utils.dart';
export 'src/color_extensions.dart';
export 'src/accessibility_utils.dart';

// Alias for compatibility with old names
export 'src/model.dart';

// New color scheme system (Phase 1)
export 'src/color_scope.dart';
export 'src/models/color_structure.dart';

// Theme color system
export 'src/models/theme_color_scheme.dart';
export 'src/providers/theme_color_providers.dart' hide ThemeColorType;
