# Project Memory: rinne-graph-desktop

## Settings Architecture (2026-02-20)

- `core_settings.SettingsManager` manages settings persistence (Settings model with `language: 'en'` default)
- `features_settings.ActiveTheme` watches `settingsManagerProvider` for theme sync
- `core_localization.LocalizationNotifier` is independent (no settings dependency); use `setLocale()` to update
- `features_settings/models/settings.dart` re-exports from `core_settings`
- `features_settings/pubspec.yaml` declares `core_settings` dependency

## Code Generation

- Run `build_runner` from `apps/desktop/` (not package directories) for reliable generation
- `core_localization` package has flutter_gen issues; `flutter build macos` still works
- After modifying providers: `cd apps/desktop && dart run build_runner build --delete-conflicting-outputs`

## Build Verification

- Always run from `apps/desktop/`: `flutter build macos`
- `melos run gen:all` fails due to circular deps in `presentation_components → core_stack_flutter`
