import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'shell_state_manager.dart';

/// Provider that manages the stack count of dialogs (Dialog/PopupRoute)
final dialogRouteCountProvider = StateProvider<int>((ref) => 0);

/// Whether one or more dialogs are open
final anyDialogOpenProvider = Provider<bool>((ref) {
  return ref.watch(dialogRouteCountProvider) > 0;
});

/// Tag to mark the next dialog to open as "important"
final nextImportantDialogTagProvider = StateProvider<String?>((ref) => null);

/// Tag of the currently open "important" dialog (null if not open)
final currentImportantDialogTagProvider = StateProvider<String?>((ref) => null);

/// Target depth when an important dialog is opened (target value of dialogRouteCount)
final importantDialogTargetDepthProvider = StateProvider<int?>((ref) => null);

/// Observer that monitors Navigator route changes and detects dialog open/close
class DialogRouteObserver extends NavigatorObserver {
  DialogRouteObserver(this.ref);
  final Ref ref;

  bool _isDialogRoute(Route<dynamic> route) {
    // Routes originating from showDialog are generally DialogRoute/RawDialogRoute(PopupRoute)
    // Target all PopupRoute, and also pick up those containing 'Dialog' in the type name just in case
    return route is PopupRoute ||
        route.runtimeType.toString().contains('Dialog');
  }

  void _inc() {
    final n = ref.read(dialogRouteCountProvider);
    ref.read(dialogRouteCountProvider.notifier).state = n + 1;
  }

  void _dec() {
    final n = ref.read(dialogRouteCountProvider);
    ref.read(dialogRouteCountProvider.notifier).state = n > 0 ? n - 1 : 0;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (_isDialogRoute(route)) {
      final before = ref.read(dialogRouteCountProvider);
      _inc();
      final pendingTag = ref.read(nextImportantDialogTagProvider);
      final currentTag = ref.read(currentImportantDialogTagProvider);
      if (pendingTag != null && currentTag == null) {
        ref.read(nextImportantDialogTagProvider.notifier).state = null;
        ref.read(currentImportantDialogTagProvider.notifier).state = pendingTag;
        ref.read(importantDialogTargetDepthProvider.notifier).state =
            before + 1;
        ref
            .read(shellStateManagerProvider.notifier)
            .markImportantDialogOpened(pendingTag);
      }
    }
  }

  void _maybeClearImportantOnClose() {
    final currentTag = ref.read(currentImportantDialogTagProvider);
    if (currentTag == null) return;
    final target = ref.read(importantDialogTargetDepthProvider) ?? 1;
    final count = ref.read(dialogRouteCountProvider);
    if (count < target) {
      ref.read(currentImportantDialogTagProvider.notifier).state = null;
      ref.read(importantDialogTargetDepthProvider.notifier).state = null;
      ref.read(shellStateManagerProvider.notifier).markImportantDialogClosed();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (_isDialogRoute(route)) {
      _dec();
      _maybeClearImportantOnClose();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (_isDialogRoute(route)) {
      _dec();
      _maybeClearImportantOnClose();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null && _isDialogRoute(oldRoute)) {
      _dec();
      _maybeClearImportantOnClose();
    }
    if (newRoute != null && _isDialogRoute(newRoute)) {
      final before = ref.read(dialogRouteCountProvider);
      _inc();
      final pendingTag = ref.read(nextImportantDialogTagProvider);
      final currentTag = ref.read(currentImportantDialogTagProvider);
      if (pendingTag != null && currentTag == null) {
        ref.read(nextImportantDialogTagProvider.notifier).state = null;
        ref.read(currentImportantDialogTagProvider.notifier).state = pendingTag;
        ref.read(importantDialogTargetDepthProvider.notifier).state =
            before + 1;
        ref
            .read(shellStateManagerProvider.notifier)
            .markImportantDialogOpened(pendingTag);
      }
    }
  }
}

/// NavigatorObserver injectable via Riverpod
final dialogRouteObserverProvider = Provider<NavigatorObserver>((ref) {
  return DialogRouteObserver(ref);
});
