# Replace UI with Fonde UI

## Overview

Replace `presentation_components` and `core_themes` with `fonde_ui` package.
Migrate from `MacosApp` to `FondeApp` (MaterialApp-based).

## Status: Completed (Phase 1)

## Completed

- [x] Step 1: Add fonde_ui to pubspec.yaml (GitHub ref + local override)
- [x] Step 2: Update `apps/desktop/main.dart` (MacosApp → MaterialApp with Fonde providers)
- [x] Step 3: Update `main_app_shell.dart` (MainShellLayout → FondeScaffold)
- [x] Step 4: Update `packages/app` (ActivityBar → FondeLaunchBar)
- [x] Step 5: Bridge `core_themes` providers to Fonde UI (backward-compat aliases)
- [x] Step 6: Fix `accessibility_settings_view.dart` (use fondeAccessibilityConfigProvider)
- [x] Step 7: Remove `macos_ui` dependency from `apps/desktop` and `packages/app`
- [x] Step 8: Build verification → ✓ Built (55.9MB)

## Architecture After Migration

### Fonde UI integration

- `fonde_ui` added to: `apps/desktop`, `packages/app`, `packages/presentation/components`, `packages/core/themes`
- Local path override in root `pubspec.yaml`: `../fonde-ui-private`
- GitHub ref: `https://github.com/szktty/fonde-ui.git` (develop branch)

### Provider bridging (core_themes → Fonde UI)

`packages/core/themes/lib/src/providers/theme_providers.dart` re-exports Fonde UI providers
and adds backward-compatible aliases:

| Old name | Now delegates to |
|---|---|
| `activeThemeProvider` | `fondeActiveThemeProvider` |
| `platformBrightnessProvider` | `fondePlatformBrightnessProvider` |
| `effectiveColorSchemeProvider` | Fonde scheme → `AppColorScheme.fromFondeColorScheme` |
| `effectiveFlutterColorSchemeProvider` | `fondeEffectiveFlutterColorSchemeProvider` |
| `effectiveThemeDataProvider` | `fondeEffectiveThemeDataProvider` |
| `accessibilityConfigProvider` | Read-only Provider wrapping `fondeAccessibilityConfigProvider` |

### Widget changes

| Old | New |
|---|---|
| `MainShellLayout` | `FondeScaffold` |
| `ActivityBar` / `ActivityBarItem` | `FondeLaunchBar` / `FondeLaunchBarItem` |
| `MacosApp` | `MaterialApp` (direct, within existing ProviderScope) |
| `MainContentArea` | `FondeMainContentArea` |
| `MainAreaTitlebar` | `FondeMainAreaTitlebar` |
| `primarySidebarStateProvider` | `fondePrimarySidebarStateProvider` |
| `secondarySidebarStateProvider` | `fondeSecondarySidebarStateProvider` |
| `perScreenSecondarySidebarStateProvider` | `fondePerScreenSecondarySidebarStateProvider` |

### Remaining (presentation_components internal widgets)

`presentation_components`内部の`App*`ウィジェット群（`AppButton`, `AppDialog`等）は
引き続き`core_themes`プロバイダーを使っているが、それらは今Fonde UIにブリッジされているので
実質的にFonde UIのプロバイダーを利用している。

## Notes

- `AppColorScheme.appSpecific` (graph/metadata/table colors) is kept in `core_themes`.
  `AppColorScheme.fromFondeColorScheme()` derives these from Fonde's ColorScheme round-trip.
- `accessibilityConfigProvider` is now a read-only `Provider<AppAccessibilityConfig>`.
  Direct mutations must use `fondeAccessibilityConfigProvider.notifier`.
- `macos_ui` fully removed from `apps/desktop` and `packages/app`.

## Failed Approaches

(none)
