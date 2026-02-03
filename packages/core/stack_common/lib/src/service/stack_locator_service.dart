import 'dart:async';
import 'dart:io';

/// Service for locating stack directories
class StackLocatorService {
  /// Recursively searches below the specified root directory and
  /// returns a list of directory paths with the `.stack` extension.
  ///
  /// [rootDirectory] The directory to start searching from.
  /// [maxDepth] Maximum depth for recursive search. Unlimited if null.
  Stream<Directory> findStacks(
    Directory rootDirectory, {
    int? maxDepth,
    bool followLinks = false,
  }) async* {
    print(
      '[StackLocatorService.findStacks] Start searching in ${rootDirectory.path} (maxDepth: $maxDepth)',
    );
    final controller = StreamController<Directory>();
    const currentDepth = 0;

    Future<void> search(Directory dir, int depth) async {
      if (maxDepth != null && depth > maxDepth) {
        return; // Stop searching if maximum depth is reached
      }

      try {
        final entities = dir.list(followLinks: followLinks);
        await for (final entity in entities) {
          // print('[StackLocatorService.findStacks] Checking entity: ${entity.path}');
          if (entity is Directory) {
            if (entity.path.endsWith('.stack')) {
              print(
                '[StackLocatorService.findStacks] Found stack: ${entity.path}',
              );
              if (!controller.isClosed) {
                controller.add(entity);
              }
            } else {
              // If not a .stack directory, search recursively
              // Skip if the target is a dot file or hidden directory (potential performance improvement)
              if (!entity.path.split('/').last.startsWith('.')) {
                await search(entity, depth + 1);
              } else {
                print(
                  '[StackLocatorService.findStacks] Skipping hidden/dot directory: ${entity.path}',
                );
              }
            }
          }
        }
      } catch (e, stackTrace) {
        // Consider access permission errors, etc.
        print(
          '[StackLocatorService.findStacks] Error listing directory ${dir.path}: $e',
        );
        print(stackTrace);
        if (!controller.isClosed) {
          controller.addError(e, stackTrace);
        }
      }
    }

    // Start search asynchronously and close the controller when complete or on error
    search(rootDirectory, currentDepth)
        .then((_) {
          if (!controller.isClosed) {
            print(
              '[StackLocatorService.findStacks] Search completed for ${rootDirectory.path}',
            );
            controller.close();
          }
        })
        .catchError((Object e, StackTrace stackTrace) {
          if (!controller.isClosed) {
            print(
              '[StackLocatorService.findStacks] Search failed for ${rootDirectory.path}: $e',
            );
            print(stackTrace);
            controller.addError(e, stackTrace);
            controller.close();
          }
        });

    yield* controller.stream;
  }
}
