// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_system_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides a FileSystemService instance

@ProviderFor(fileSystemService)
final fileSystemServiceProvider = FileSystemServiceProvider._();

/// Provider that provides a FileSystemService instance

final class FileSystemServiceProvider
    extends
        $FunctionalProvider<
          FileSystemService,
          FileSystemService,
          FileSystemService
        >
    with $Provider<FileSystemService> {
  /// Provider that provides a FileSystemService instance
  FileSystemServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileSystemServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileSystemServiceHash();

  @$internal
  @override
  $ProviderElement<FileSystemService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileSystemService create(Ref ref) {
    return fileSystemService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileSystemService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileSystemService>(value),
    );
  }
}

String _$fileSystemServiceHash() => r'9c81ed79e3bd7c50d578550928af8bed13e69982';

/// Provider that provides the application's documents directory

@ProviderFor(documentsDirectory)
final documentsDirectoryProvider = DocumentsDirectoryProvider._();

/// Provider that provides the application's documents directory

final class DocumentsDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider that provides the application's documents directory
  DocumentsDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return documentsDirectory(ref);
  }
}

String _$documentsDirectoryHash() =>
    r'23c2da1229a7ee858c7ba5590040801b85469b3c';

/// Provider that provides the application's support directory

@ProviderFor(supportDirectory)
final supportDirectoryProvider = SupportDirectoryProvider._();

/// Provider that provides the application's support directory

final class SupportDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider that provides the application's support directory
  SupportDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return supportDirectory(ref);
  }
}

String _$supportDirectoryHash() => r'93e853c3ad19975cdbdff211a9d7d38312e1c637';

/// Provider that provides the application's temporary directory

@ProviderFor(temporaryDirectory)
final temporaryDirectoryProvider = TemporaryDirectoryProvider._();

/// Provider that provides the application's temporary directory

final class TemporaryDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider that provides the application's temporary directory
  TemporaryDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temporaryDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temporaryDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return temporaryDirectory(ref);
  }
}

String _$temporaryDirectoryHash() =>
    r'd5a7c214e98959e5117d0cca0dad7e6bf67249ae';

/// Provider that provides file system operations

@ProviderFor(fileSystemOperations)
final fileSystemOperationsProvider = FileSystemOperationsProvider._();

/// Provider that provides file system operations

final class FileSystemOperationsProvider
    extends
        $FunctionalProvider<
          FileSystemOperations,
          FileSystemOperations,
          FileSystemOperations
        >
    with $Provider<FileSystemOperations> {
  /// Provider that provides file system operations
  FileSystemOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileSystemOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileSystemOperationsHash();

  @$internal
  @override
  $ProviderElement<FileSystemOperations> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileSystemOperations create(Ref ref) {
    return fileSystemOperations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileSystemOperations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileSystemOperations>(value),
    );
  }
}

String _$fileSystemOperationsHash() =>
    r'fcbe8a7379b07cda8442814854da2661a3731c17';
