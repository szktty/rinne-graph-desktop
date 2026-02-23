// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the tab state for metadata management

@ProviderFor(MetadataTabState)
final metadataTabStateProvider = MetadataTabStateProvider._();

/// Provider that manages the tab state for metadata management
final class MetadataTabStateProvider
    extends $NotifierProvider<MetadataTabState, String> {
  /// Provider that manages the tab state for metadata management
  MetadataTabStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metadataTabStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metadataTabStateHash();

  @$internal
  @override
  MetadataTabState create() => MetadataTabState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$metadataTabStateHash() => r'5a19b50d0920ace5faffcb192b2294bd12cb706a';

/// Provider that manages the tab state for metadata management

abstract class _$MetadataTabState extends $Notifier<String> {
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

/// Provider that provides a list of available metadata tabs

@ProviderFor(availableMetadataTabs)
final availableMetadataTabsProvider = AvailableMetadataTabsProvider._();

/// Provider that provides a list of available metadata tabs

final class AvailableMetadataTabsProvider
    extends
        $FunctionalProvider<
          List<MetadataTab>,
          List<MetadataTab>,
          List<MetadataTab>
        >
    with $Provider<List<MetadataTab>> {
  /// Provider that provides a list of available metadata tabs
  AvailableMetadataTabsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableMetadataTabsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableMetadataTabsHash();

  @$internal
  @override
  $ProviderElement<List<MetadataTab>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<MetadataTab> create(Ref ref) {
    return availableMetadataTabs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MetadataTab> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MetadataTab>>(value),
    );
  }
}

String _$availableMetadataTabsHash() =>
    r'0151dccfaeb7ce6d992173c59df6a51ece41f89d';
