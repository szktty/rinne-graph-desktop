// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_entity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that monitors the selected entity and sets it in the editor
/// Using unified core_graph provider
///
/// Note: Not using AutoDispose keeps the state persistent even when switching screens

@ProviderFor(selectedEntityForEditor)
final selectedEntityForEditorProvider = SelectedEntityForEditorProvider._();

/// Provider that monitors the selected entity and sets it in the editor
/// Using unified core_graph provider
///
/// Note: Not using AutoDispose keeps the state persistent even when switching screens

final class SelectedEntityForEditorProvider
    extends $FunctionalProvider<Entity?, Entity?, Entity?>
    with $Provider<Entity?> {
  /// Provider that monitors the selected entity and sets it in the editor
  /// Using unified core_graph provider
  ///
  /// Note: Not using AutoDispose keeps the state persistent even when switching screens
  SelectedEntityForEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityForEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityForEditorHash();

  @$internal
  @override
  $ProviderElement<Entity?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Entity? create(Ref ref) {
    return selectedEntityForEditor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Entity? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Entity?>(value),
    );
  }
}

String _$selectedEntityForEditorHash() =>
    r'fe15e6be135931c997ade68262cd10f2b132f1c5';
