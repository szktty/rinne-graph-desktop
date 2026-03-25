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
    extends $NotifierProvider<ToolbarStateManager, FondeToolbarState> {
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
  Override overrideWithValue(FondeToolbarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeToolbarState>(value),
    );
  }
}

String _$toolbarStateManagerHash() =>
    r'1830aca2e41ac0170b6dd0b0bd1f58176c6858c7';

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.

abstract class _$ToolbarStateManager extends $Notifier<FondeToolbarState> {
  FondeToolbarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FondeToolbarState, FondeToolbarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FondeToolbarState, FondeToolbarState>,
              FondeToolbarState,
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

String _$toolbarActionsHash() => r'c83e4aca4e3fbdd8b0b9b6d507b962ae90caf279';
