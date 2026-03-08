/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

library;

// ============================================================
// Fonde UI — re-exported directly
// ============================================================
export 'package:fonde_ui/fonde_ui.dart';
export 'package:fonde_ui/fonde_ui_riverpod.dart';

// Fonde UI internals not in public barrel
export 'package:fonde_ui/src/widgets/styling/fonde_border.dart'
    show FondeBorderWidth, FondeBorder, FondeBorderContainer;
export 'package:fonde_ui/src/widgets/widgets/fonde_rectangle_border.dart'
    show fondeBorderRadiusProvider, FondeBorderRadiusProvider;

// ============================================================
// Providers (RinneGraph-specific)
// ============================================================
export 'src/providers/navigation_providers.dart';
export 'src/providers/search_providers.dart';

// ============================================================
// Layout (RinneGraph-specific shell)
// ============================================================
export 'src/layout/main_shell_layout.dart';

// ============================================================
// Typography (RinneGraph-specific — AppText / AppTextVariant)
// ============================================================
export 'src/typography/app_text.dart';
export 'src/typography/app_text_style_builder.dart';

// ============================================================
// Master-detail search (uses local fondeSearchQueryProvider)
// ============================================================
export 'src/master_detail/master_detail_search.dart';

// ============================================================
// Identifiable Widget helpers
// ============================================================
export 'src/identifiable_widget/identifiable_widget_exports.dart';
export 'src/id/uuid_generator.dart';

// ============================================================
// RinneGraph-specific widgets (no Fonde equivalent)
// ============================================================
export 'src/widgets/action_menu.dart';
export 'src/widgets/app_arrow_line.dart';
export 'src/widgets/app_color_picker.dart';
export 'src/widgets/app_page.dart';
export 'src/widgets/selectable_card.dart';
export 'src/widgets/app_dialog.dart';

// ============================================================
// Constants / Icons
// ============================================================
export 'src/constants/macos_constants.dart';
export 'src/icons/app_icons.dart';

// ============================================================
// Decorators (tappable — no Fonde equivalent)
// ============================================================
export 'src/decorators/tappable.dart';

// ============================================================
// Navigation (RinneGraph-specific — search field, identifiable)
// ============================================================
export 'src/navigation/navigation_search_field.dart';
export 'src/navigation/identifiable_navigation_item.dart';

// ============================================================
// Details Pane / Stack Grid / Stack Selection / Status Bar
// ============================================================
export 'src/details_pane/details_pane.dart';
export 'src/stack_grid/app_stack_grid.dart';
export 'src/stack_selection/stack_selection_panel.dart';
export 'src/status_bar/graph_navigator_status_bar.dart';
export 'src/status_bar/status_bar_utils.dart';

// ============================================================
// Dialogs (RinneGraph-specific — ErrorDialogData etc.)
// ============================================================
export 'src/dialogs/error_dialog.dart';
