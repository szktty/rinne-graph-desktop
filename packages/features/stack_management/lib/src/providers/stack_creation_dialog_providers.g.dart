// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_creation_dialog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Form name state for stack creation dialog

@ProviderFor(FormNameState)
final formNameStateProvider = FormNameStateProvider._();

/// Form name state for stack creation dialog
final class FormNameStateProvider
    extends $NotifierProvider<FormNameState, String> {
  /// Form name state for stack creation dialog
  FormNameStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formNameStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formNameStateHash();

  @$internal
  @override
  FormNameState create() => FormNameState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$formNameStateHash() => r'c7755476d78aa30bd2457157966fe2938b7998d1';

/// Form name state for stack creation dialog

abstract class _$FormNameState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Form save path state for stack creation dialog

@ProviderFor(FormSavePathState)
final formSavePathStateProvider = FormSavePathStateProvider._();

/// Form save path state for stack creation dialog
final class FormSavePathStateProvider
    extends $NotifierProvider<FormSavePathState, String> {
  /// Form save path state for stack creation dialog
  FormSavePathStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formSavePathStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formSavePathStateHash();

  @$internal
  @override
  FormSavePathState create() => FormSavePathState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$formSavePathStateHash() => r'bac8e7bd57b0a02869bde6c55945990213467960';

/// Form save path state for stack creation dialog

abstract class _$FormSavePathState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
