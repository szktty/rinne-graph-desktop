# Large File Analysis

Analysis of Dart source files over 300 lines, with splitting candidates identified. Generated files and stable data-definition files are excluded from splitting candidates.

## Files Excluded from Splitting

| File | Lines | Reason |
|------|------:|--------|
| `core_localization/app_localizations.dart` | 986 | Auto-generated (Flutter l10n) |
| `core_localization/app_localizations_en.dart` | 451 | Auto-generated |
| `core_localization/app_localizations_ja.dart` | 448 | Auto-generated |
| `core_themes/color_structure.dart` | 1546 | Color definition data — large but structurally simple |
| `core_themes/app_color_scheme.dart` | 783 | Theme scheme mappings |
| `core_themes/app_typography_config.dart` | 495 | Typography definitions |
| `core_themes/color_scope.dart` | 308 | Scope model |
| `core_graph_common/property_type.dart` | 381 | Enum-like type definitions |
| `presentation_components/app_dropdown_menu.dart` | 877 | Shared component, stable |
| `presentation_components/app_popover.dart` | 861 | Shared component, stable |
| `presentation_components/app_popup_menu.dart` | 584 | Shared component, stable |
| `presentation_components/app_split_button.dart` | 581 | Shared component, stable |
| `presentation_components/app_dialog.dart` | 534 | Shared component, stable |
| `presentation_components/app_text_field.dart` | 518 | Shared component, stable |
| `presentation_components/app_button.dart` | 496 | Shared component, stable |
| `presentation_components/app_table_view.dart` | 495 | Shared component, stable |
| `presentation_components/app_stack_grid.dart` | 738 | Shared component, stable |
| `presentation_components/app_gesture_detector.dart` | 446 | Shared component, stable |
| `presentation_components/app_padding.dart` | 335 | Spacing definitions |
| Other `presentation_components` 300-line files | — | Shared components, infrequently modified |

## Splitting Candidates

### High Priority

Files that are large, frequently modified, and sit in critical data flow paths.

| Lines | Package | File | Why Split |
|------:|---------|------|-----------|
| 1758 | features_welcome | `import_dialog.dart` | Largest file. Likely contains multiple dialog steps/wizards in one file. |
| 987 | desktop | `graph_view.dart` | Core graph rendering widget. Touched whenever graph features change. |
| 878 | desktop | `register_core_commands.dart` | Command registration. Grows with every new feature. |
| 726 | features_record_editor | `record_editor.dart` | Node editing UI — origin of all CRUD operations from UI. |

### Medium Priority

Large files that are modified less frequently but still complex enough to cause edit failures.

| Lines | Package | File | Why Split |
|------:|---------|------|-----------|
| 1029 | core_graph_common | `rinne_graph_storage.dart` | Storage implementation with CRUD for nodes, links, metadata. Core data flow but lower change frequency. |
| 831 | desktop | `advanced_property_filter_panel.dart` | Filter UI panel with complex state. |
| 771 | desktop | `graph_navigator_sidebar.dart` | Sidebar navigation UI. |
| 731 | core_samples | `stack_template_installer.dart` | Template installation logic. |
| 726 | features_record_editor | `custom_reorderable_list.dart` | Custom widget, may contain multiple helper widgets. |
| 622 | features_record_editor | `tabbed_record_editor.dart` | Tabbed editor wrapping record_editor. |
| 585 | desktop | `menu_builder.dart` | Menu construction. Grows with new menu items. |
| 569 | desktop | `advanced_search_models.dart` | Search model definitions. |
| 528 | features_welcome | `welcome_screen_dialogs.dart` | Multiple dialogs in one file. |

### Lower Priority

Files that are borderline (300-500 lines) and may not need splitting yet, but worth monitoring.

| Lines | Package | File |
|------:|---------|------|
| 513 | desktop | `navigation_tab_content.dart` |
| 475 | desktop | `graph_toolbar.dart` |
| 460 | features_record_editor | `graph_entity_properties_display.dart` |
| 459 | desktop | `data_converter_service.dart` |
| 446 | core_stack_flutter | `stack_providers.dart` |
| 436 | desktop | `advanced_query_converter.dart` |
| 434 | core_graph_common | `traversal_converter.dart` |
| 434 | core_graph_common | `graph_context_impl.dart` |
| 422 | features_record_editor | `property_editor.dart` |
| 412 | core_workflow | `task.dart` |
| 400 | core_undo | `node_commands.dart` |
| 385 | core_stack_common | `dataset_service.dart` |
| 383 | core_graph_flutter | `graph_providers.dart` |

## Hotspot Packages

Packages with the most large files, indicating structural complexity.

| Package | 300+ Line Files | Total Lines | Notes |
|---------|----------------:|------------:|-------|
| presentation_components | 18 | 8,453 | Mostly stable shared components — low splitting priority |
| desktop (app) | 13 | 7,261 | Mix of UI widgets and services — high splitting priority |
| core_graph_common | 8 | 4,401 | Storage and context — medium priority |
| features_record_editor | 5 | 2,956 | Editor UI — high priority |
| features_welcome | 4 | 2,977 | Dialogs — high priority |
| core_themes | 4 | 3,132 | Mostly data definitions — low priority |
