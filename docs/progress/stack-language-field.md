# Stack Language Field Implementation Progress

## Status: COMPLETED

## Summary

Added `language` field to stacks, enabling language-based filtering on the welcome screen.

## Completed Steps

1. **StackInfo model** (`packages/core/stack_common/lib/src/model/stack_info.dart`)
   - Added `language` field (String?) to constructor, fromJson, toJson, copyWith, ==, hashCode

2. **Sample manifest.json files**
   - `team/manifest.json` → `"language": "en"`
   - `meiji/manifest.json` → `"language": "ja"`
   - `simple_graph/manifest.json` → `"language": "en"`

3. **StackTemplateManifest** (`packages/core/samples/lib/src/models/stack_template_manifest.dart`)
   - Added `language` field with fromJson/toJson support

4. **StackTemplateService** (`packages/core/samples/lib/src/service/stack_template_service.dart`)
   - Added `language` to all three hardcoded template definitions

5. **StackTemplateInstaller** (`packages/core/samples/lib/src/service/stack_template_installer.dart`)
   - `_createInfoJson` reads `metadata['language']` and writes to info.json

6. **StackManagementService** (`packages/features/stack_management/lib/src/services/stack_management_service.dart`)
   - Added `language` parameter to `createNewStack`, `_createStackFromResult`, `_createMetadataFiles`

7. **Welcome action buttons** (`packages/features/welcome/lib/src/widgets/welcome_screen_action_buttons.dart`)
   - Passes `Localizations.localeOf(context).languageCode` to `createNewStack`

8. **ARB localization keys** added to both `app_en.arb` and `app_ja.arb`:
   - `welcome_filter_language_all`, `welcome_filter_language_unspecified`, `welcome_filter_language_label`
   - `language_name_en`, `language_name_ja`

9. **Code generation** ran for localization and welcome providers

10. **WelcomeLanguageFilter provider** (`packages/features/welcome/lib/src/providers/welcome_providers.dart`)
    - Persists filter state via `settingsStorageServiceProvider`

11. **Language filter dropdown** (`packages/features/welcome/lib/src/widgets/welcome_language_filter_dropdown.dart`)
    - New widget file; dynamically builds options from stack list
    - Also exports `filterStacksByLanguage()` utility function

12. **Stack grid filtering** (`packages/features/welcome/lib/src/widgets/welcome_screen_stack_grid.dart`)
    - Watches `welcomeLanguageFilterProvider` and applies filter

13. **Welcome content** (`packages/features/welcome/lib/src/widgets/welcome_screen_content.dart`)
    - Added `WelcomeLanguageFilterDropdown` to both My Stacks and Samples tabs

14. **Documentation** updated:
    - `docs/stack/stack_specification.md` — `language` listed as optional field
    - `docs/stack/stack_exchange_format_specification.md` — `language` added to manifest example

## Design Decisions

- Used `Localizations.localeOf(context)` instead of `core_localization` provider to avoid complex transitive dependency issues (`flutter_localizations` SDK dep)
- Language names are hardcoded in the dropdown widget (only en/ja supported currently) rather than using `AppLocalizations`, for the same dependency reason
- The `core_localization` pubspec dependency was NOT added to welcome package

## Notes

- Existing stacks without `language` field are treated as "unspecified"
- Already-installed sample stacks won't have `language` until re-created
- Filter state persists across app restarts via settings storage
