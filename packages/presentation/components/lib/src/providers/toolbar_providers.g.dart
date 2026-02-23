// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toolbar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.

@ProviderFor(ToolbarStateManager)
final toolbarStateManagerProvider = ToolbarStateManagerProvider._();

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.
final class ToolbarStateManagerProvider
    extends $NotifierProvider<ToolbarStateManager, toolbar_state.ToolbarState> {
  /// Provider that manages the state of the toolbar.
  ///
  /// Manages the selected tool and the set of enabled tools.
  ToolbarStateManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toolbarStateManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toolbarStateManagerHash();

  @$internal
  @override
  ToolbarStateManager create() => ToolbarStateManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(toolbar_state.ToolbarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<toolbar_state.ToolbarState>(value),
    );
  }
}

String _$toolbarStateManagerHash() =>
    r'a4a5d059da2c29066a7e42e99e45098a78c6f3fc';

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.

abstract class _$ToolbarStateManager
    extends $Notifier<toolbar_state.ToolbarState> {
  toolbar_state.ToolbarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<toolbar_state.ToolbarState, toolbar_state.ToolbarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                toolbar_state.ToolbarState,
                toolbar_state.ToolbarState
              >,
              toolbar_state.ToolbarState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that supplies toolbar actions.

@ProviderFor(toolbarActions)
final toolbarActionsProvider = ToolbarActionsProvider._();

/// Provider that supplies toolbar actions.

final class ToolbarActionsProvider
    extends $FunctionalProvider<ToolbarActions, ToolbarActions, ToolbarActions>
    with $Provider<ToolbarActions> {
  /// Provider that supplies toolbar actions.
  ToolbarActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toolbarActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toolbarActionsHash();

  @$internal
  @override
  $ProviderElement<ToolbarActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ToolbarActions create(Ref ref) {
    return toolbarActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToolbarActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToolbarActions>(value),
    );
  }
}

String _$toolbarActionsHash() => r'a775ad62f507a890c425b16f364406cfe0219302';
