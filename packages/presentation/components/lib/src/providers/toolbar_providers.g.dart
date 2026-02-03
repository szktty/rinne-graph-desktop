// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toolbar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$toolbarActionsHash() => r'a775ad62f507a890c425b16f364406cfe0219302';

/// Provider that supplies toolbar actions.
///
/// Copied from [toolbarActions].
@ProviderFor(toolbarActions)
final toolbarActionsProvider = AutoDisposeProvider<ToolbarActions>.internal(
  toolbarActions,
  name: r'toolbarActionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$toolbarActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ToolbarActionsRef = AutoDisposeProviderRef<ToolbarActions>;
String _$toolbarStateManagerHash() =>
    r'a4a5d059da2c29066a7e42e99e45098a78c6f3fc';

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.
///
/// Copied from [ToolbarStateManager].
@ProviderFor(ToolbarStateManager)
final toolbarStateManagerProvider = AutoDisposeNotifierProvider<
  ToolbarStateManager,
  toolbar_state.ToolbarState
>.internal(
  ToolbarStateManager.new,
  name: r'toolbarStateManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$toolbarStateManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ToolbarStateManager = AutoDisposeNotifier<toolbar_state.ToolbarState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
