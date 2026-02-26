import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Lightweight handle to expose screen (dialog) specific actions for UI tests
class WelcomeDialogTestActions {
  final VoidCallback? pressCreateNew;
  final VoidCallback? pressOpen;
  final VoidCallback? pressImport;
  final VoidCallback? pressClose;

  const WelcomeDialogTestActions({
    this.pressCreateNew,
    this.pressOpen,
    this.pressImport,
    this.pressClose,
  });

  bool get hasAny =>
      pressCreateNew != null ||
      pressOpen != null ||
      pressImport != null ||
      pressClose != null;
}

/// Test actions associated with the currently displayed welcome dialog
final welcomeDialogTestActionsProvider =
    StateProvider<WelcomeDialogTestActions>(
      (_) => const WelcomeDialogTestActions(),
    );
