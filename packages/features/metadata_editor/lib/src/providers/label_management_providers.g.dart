// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_management_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the label search query.

@ProviderFor(LabelSearchQuery)
final labelSearchQueryProvider = LabelSearchQueryProvider._();

/// Provider that manages the label search query.
final class LabelSearchQueryProvider
    extends $NotifierProvider<LabelSearchQuery, String> {
  /// Provider that manages the label search query.
  LabelSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'labelSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$labelSearchQueryHash();

  @$internal
  @override
  LabelSearchQuery create() => LabelSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$labelSearchQueryHash() => r'a0e3d41298fa4dce853e7fe526d381a7b3073f81';

/// Provider that manages the label search query.

abstract class _$LabelSearchQuery extends $Notifier<String> {
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

/// Provider that manages the selected label.

@ProviderFor(SelectedLabel)
final selectedLabelProvider = SelectedLabelProvider._();

/// Provider that manages the selected label.
final class SelectedLabelProvider
    extends $NotifierProvider<SelectedLabel, LabelMetadata?> {
  /// Provider that manages the selected label.
  SelectedLabelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLabelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLabelHash();

  @$internal
  @override
  SelectedLabel create() => SelectedLabel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LabelMetadata? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LabelMetadata?>(value),
    );
  }
}

String _$selectedLabelHash() => r'bdd238ef135653ac7b969d74bbdc938c35df8322';

/// Provider that manages the selected label.

abstract class _$SelectedLabel extends $Notifier<LabelMetadata?> {
  LabelMetadata? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LabelMetadata?, LabelMetadata?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LabelMetadata?, LabelMetadata?>,
              LabelMetadata?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that offers label management actions.

@ProviderFor(LabelActions)
final labelActionsProvider = LabelActionsProvider._();

/// Provider that offers label management actions.
final class LabelActionsProvider extends $NotifierProvider<LabelActions, void> {
  /// Provider that offers label management actions.
  LabelActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'labelActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$labelActionsHash();

  @$internal
  @override
  LabelActions create() => LabelActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$labelActionsHash() => r'9c2c783f5be527451b49d1d4c4885bd8ff9e6889';

/// Provider that offers label management actions.

abstract class _$LabelActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that provides a filtered list of labels.

@ProviderFor(filteredLabels)
final filteredLabelsProvider = FilteredLabelsProvider._();

/// Provider that provides a filtered list of labels.

final class FilteredLabelsProvider
    extends
        $FunctionalProvider<
          List<LabelMetadata>,
          List<LabelMetadata>,
          List<LabelMetadata>
        >
    with $Provider<List<LabelMetadata>> {
  /// Provider that provides a filtered list of labels.
  FilteredLabelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredLabelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredLabelsHash();

  @$internal
  @override
  $ProviderElement<List<LabelMetadata>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<LabelMetadata> create(Ref ref) {
    return filteredLabels(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LabelMetadata> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LabelMetadata>>(value),
    );
  }
}

String _$filteredLabelsHash() => r'c5037194749a3f98f2eaad12179cf4a4cc6f066a';
