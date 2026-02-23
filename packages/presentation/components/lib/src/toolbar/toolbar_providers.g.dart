// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toolbar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the state of the toolbar.

@ProviderFor(ToolbarStateNotifier)
final toolbarStateProvider = ToolbarStateNotifierProvider._();

/// Provider that manages the state of the toolbar.
final class ToolbarStateNotifierProvider
    extends
        $NotifierProvider<ToolbarStateNotifier, toolbar_models.ToolbarState> {
  /// Provider that manages the state of the toolbar.
  ToolbarStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toolbarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toolbarStateNotifierHash();

  @$internal
  @override
  ToolbarStateNotifier create() => ToolbarStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(toolbar_models.ToolbarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<toolbar_models.ToolbarState>(value),
    );
  }
}

String _$toolbarStateNotifierHash() =>
    r'870166a9a21102d682edce26a50eedc2a77d43dc';

/// Provider that manages the state of the toolbar.

abstract class _$ToolbarStateNotifier
    extends $Notifier<toolbar_models.ToolbarState> {
  toolbar_models.ToolbarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<toolbar_models.ToolbarState, toolbar_models.ToolbarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                toolbar_models.ToolbarState,
                toolbar_models.ToolbarState
              >,
              toolbar_models.ToolbarState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
