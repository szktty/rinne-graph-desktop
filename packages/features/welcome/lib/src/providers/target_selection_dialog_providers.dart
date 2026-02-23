import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Target selection dialog visibility state (for UI testing).
final targetSelectionDialogShowingProvider = StateProvider<bool>(
  (ref) => false,
);

/// Action handle for UI testing.
class TargetSelectionDialogTestActions {
  final void Function(int index)? selectIndex; // Select stack by index
  final void Function()? confirm; // Confirm OK with current selection
  final void Function()? cancel; // Cancel (pop)

  const TargetSelectionDialogTestActions({
    this.selectIndex,
    this.confirm,
    this.cancel,
  });

  bool get hasAny => selectIndex != null || confirm != null || cancel != null;
}

/// Test actions associated with the currently displayed target selection dialog.
final targetSelectionDialogTestActionsProvider =
    StateProvider<TargetSelectionDialogTestActions>(
      (ref) => const TargetSelectionDialogTestActions(),
    );
