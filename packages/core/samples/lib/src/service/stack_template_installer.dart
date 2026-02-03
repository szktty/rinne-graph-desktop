import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:core_graph_common/core_graph_common.dart';
import 'package:core_exchange/exchange.dart';

/// Service to generate stacks from stack templates
///
/// Reads template manifest files conforming to stack exchange format
/// and generates stacks in the file system.
class StackTemplateInstaller {
  /// Generate stack from stack template
  ///
  /// [templateAssetPath] Directory path containing template manifest file in assets
  /// [outputDirectory] Output directory
  /// [stackName] Stack name to generate (if omitted, taken from template)
  ///
  /// Returns: Directory path of generated stack, null on failure
  Future<String?> generateStackFromTemplate({
    required String templateAssetPath,
    required Directory outputDirectory,
    String? stackName,
  }) async {
    try {
      debugPrint(
        '[ManifestStackInstaller] Starting stack generation: template=$templateAssetPath -> output=${outputDirectory.path}',
      );

      // 1. Load template manifest file
      final manifest = await _loadManifestFromAsset(templateAssetPath);
      if (manifest == null) {
        debugPrint(
          '[ManifestStackInstaller] Failed to load template manifest from: $templateAssetPath',
        );
        return null;
      }

      // 2. Determine stack name
      final finalStackName =
          stackName ??
          manifest['metadata']?['name'] ??
          path.basename(templateAssetPath);

      debugPrint(
        '[ManifestStackInstaller] Determined stack name: $finalStackName',
      );

      // 3. Create output directory (with .stack extension)
      final stackDir = Directory(
        path.join(outputDirectory.path, '$finalStackName.stack'),
      );
      if (await stackDir.exists()) {
        debugPrint(
          '[ManifestStackInstaller] Stack directory already exists: ${stackDir.path}',
        );
        // Complement missing parts of existing directory
        await _ensureStackStructure(stackDir);

        // Execute data import (even for existing directory)
        debugPrint('[ManifestStackInstaller] Starting data import...');
        await _importDataToDatabase(stackDir, manifest, templateAssetPath);

        return stackDir.path;
      }

      debugPrint(
        '[ManifestStackInstaller] Creating stack directory: ${stackDir.path}',
      );
      await stackDir.create(recursive: true);

      // 4. Create metadata directory
      final metaDir = Directory(path.join(stackDir.path, 'meta'));
      debugPrint(
        '[ManifestStackInstaller] Creating meta directory: ${metaDir.path}',
      );
      await metaDir.create();

      // 5. Create data directory
      final dataDir = Directory(path.join(stackDir.path, 'data'));
      debugPrint(
        '[ManifestStackInstaller] Creating data directory: ${dataDir.path}',
      );
      await dataDir.create();

      // 6. Generate info.json
      debugPrint('[ManifestStackInstaller] Generating info.json...');
      await _createInfoJson(stackDir, manifest);

      // 7. Generate settings.json
      debugPrint('[ManifestStackInstaller] Generating settings.json...');
      await _createSettingsJson(stackDir);

      // 7.5. Copy thumbnail image (if exists)
      debugPrint('[ManifestStackInstaller] Processing thumbnail image...');
      await _processThumbnailImage(templateAssetPath, stackDir, manifest);

      // 8. Create RinneGraph database
      debugPrint('[ManifestStackInstaller] Creating RinneGraph database...');
      await _createGraphDatabase(stackDir);

      // 9. Import data files to RinneGraph database
      debugPrint('[ManifestStackInstaller] Starting data import...');
      await _importDataToDatabase(stackDir, manifest, templateAssetPath);

      // 7. Process template data files
      debugPrint('[ManifestStackInstaller] Processing template data files...');
      await _processDataFiles(templateAssetPath, stackDir, manifest);

      // 8. Process schema file (if exists)
      debugPrint('[ManifestStackInstaller] Processing schema file...');
      await _processSchemaFile(templateAssetPath, stackDir, manifest);

      debugPrint(
        '[ManifestStackInstaller] Stack generation completed: ${stackDir.path}',
      );
      return stackDir.path;
    } catch (e, stackTrace) {
      debugPrint(
        '[ManifestStackInstaller] Error creating stack from manifest: $e',
      );
      debugPrint('[ManifestStackInstaller] Stack trace: $stackTrace');
      return null;
    }
  }

  /// Legacy method name for backward compatibility
  ///
  /// [assetPath] Directory path containing manifest file in assets
  /// [outputDirectory] Output directory
  /// [stackName] Stack name to generate (if omitted, taken from manifest)
  ///
  /// Returns: Directory path of generated stack, null on failure
  @Deprecated('Use generateStackFromTemplate instead')
  Future<String?> createStackFromManifest({
    required String assetPath,
    required Directory outputDirectory,
    String? stackName,
  }) async {
    return generateStackFromTemplate(
      templateAssetPath: assetPath,
      outputDirectory: outputDirectory,
      stackName: stackName,
    );
  }

  /// Load template manifest file from assets
  Future<Map<String, dynamic>?> _loadManifestFromAsset(String assetPath) async {
    try {
      final manifestPath = '$assetPath/manifest.json';
      final manifestContent = await rootBundle.loadString(manifestPath);
      return json.decode(manifestContent) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[ManifestStackInstaller] Failed to load manifest: $e');
      return null;
    }
  }

  /// Generate info.json file
  Future<void> _createInfoJson(
    Directory stackDir,
    Map<String, dynamic> manifest,
  ) async {
    final metadata = manifest['metadata'] as Map<String, dynamic>? ?? {};

    final info = {
      'name': metadata['name'] ?? 'Unknown Stack',
      'description': metadata['description'] ?? '',
      'author': metadata['author'] ?? 'Unknown',
      'version': metadata['version'] ?? '1.0.0',
      'createdAt': metadata['created_at'] ?? DateTime.now().toIso8601String(),
      'lastModifiedAt': DateTime.now().toIso8601String(),
      'tags': metadata['tags'] ?? [],
    };

    final infoFile = File(path.join(stackDir.path, 'meta', 'info.json'));
    await infoFile.writeAsString(json.encode(info));
  }

  /// Generate settings.json file
  Future<void> _createSettingsJson(Directory stackDir) async {
    final settings = {
      'theme': 'default',
      'layout': 'default',
      'preferences': {},
    };

    final settingsFile = File(
      path.join(stackDir.path, 'meta', 'settings.json'),
    );
    await settingsFile.writeAsString(json.encode(settings));
  }

  /// Process data files
  Future<void> _processDataFiles(
    String assetPath,
    Directory stackDir,
    Map<String, dynamic> manifest,
  ) async {
    final files = manifest['files'] as List<dynamic>? ?? [];

    final allNodes = <Map<String, dynamic>>[];
    final allLinks = <Map<String, dynamic>>[];

    // Process each data file
    for (final fileName in files) {
      try {
        final filePath = '$assetPath/$fileName';
        final fileContent = await rootBundle.loadString(filePath);
        final data = json.decode(fileContent);

        // If file is in array format (nodes.json, links.json, etc.)
        if (data is List<dynamic>) {
          if (fileName.toLowerCase().contains('node')) {
            // Process node file
            allNodes.addAll(data.cast<Map<String, dynamic>>());
          } else if (fileName.toLowerCase().contains('link')) {
            // Process link file
            allLinks.addAll(data.cast<Map<String, dynamic>>());
          }
        } else if (data is Map<String, dynamic>) {
          // If file is in object format (legacy format)
          // Extract node data
          if (data.containsKey('nodes')) {
            final nodes = data['nodes'] as List<dynamic>;
            allNodes.addAll(nodes.cast<Map<String, dynamic>>());
          }

          // Extract link data
          if (data.containsKey('links')) {
            final links = data['links'] as List<dynamic>;
            allLinks.addAll(links.cast<Map<String, dynamic>>());
          }
        }
      } catch (e) {
        debugPrint(
          '[ManifestStackInstaller] Failed to process file $fileName: $e',
        );
        // Skip and continue even if error occurs
      }
    }

    // Create integrated data file
    if (allNodes.isNotEmpty || allLinks.isNotEmpty) {
      final graphData = <String, dynamic>{};
      if (allNodes.isNotEmpty) graphData['nodes'] = allNodes;
      if (allLinks.isNotEmpty) graphData['links'] = allLinks;

      final dataFile = File(path.join(stackDir.path, 'data.json'));
      await dataFile.writeAsString(json.encode(graphData));
    }
  }

  /// Process schema file
  Future<void> _processSchemaFile(
    String assetPath,
    Directory stackDir,
    Map<String, dynamic> manifest,
  ) async {
    try {
      // If schema file is specified in manifest
      final schemaFileName = manifest['schema'] as String?;
      if (schemaFileName != null) {
        final schemaPath = '$assetPath/$schemaFileName';
        final schemaContent = await rootBundle.loadString(schemaPath);

        final schemaFile = File(path.join(stackDir.path, 'schema.json'));
        await schemaFile.writeAsString(schemaContent);
        return;
      }

      // Check for default schema.json file
      try {
        final defaultSchemaPath = '$assetPath/schema.json';
        final schemaContent = await rootBundle.loadString(defaultSchemaPath);

        final schemaFile = File(path.join(stackDir.path, 'schema.json'));
        await schemaFile.writeAsString(schemaContent);
      } catch (e) {
        // Skip if schema file doesn't exist
        debugPrint('[ManifestStackInstaller] No schema file found, skipping');
      }
    } catch (e) {
      debugPrint('[ManifestStackInstaller] Failed to process schema file: $e');
      // Continue stack generation even if schema file processing fails
    }
  }

  /// Check if manifest file exists in assets
  Future<bool> hasManifestFile(String assetPath) async {
    try {
      final manifestPath = '$assetPath/manifest.json';
      await rootBundle.loadString(manifestPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get only metadata from manifest file
  Future<Map<String, dynamic>?> getManifestMetadata(String assetPath) async {
    final manifest = await _loadManifestFromAsset(assetPath);
    return manifest?['metadata'] as Map<String, dynamic>?;
  }

  /// Create RinneGraph database
  Future<void> _createGraphDatabase(Directory stackDir) async {
    final dbPath = path.join(stackDir.path, 'data', 'graph.db');

    try {
      // Create RinneGraph database using DatabaseCreator
      final result = await DatabaseCreator.createEmptyDatabase(dbPath);

      if (result) {
        debugPrint(
          '[ManifestStackInstaller] RinneGraph database created successfully: $dbPath',
        );
      } else {
        debugPrint(
          '[ManifestStackInstaller] RinneGraph database creation failed: $dbPath',
        );
        // Fallback: create empty file
        final dbFile = File(dbPath);
        await dbFile.create();
        debugPrint(
          '[ManifestStackInstaller] Fallback: created empty database file: $dbPath',
        );
      }
    } catch (e) {
      debugPrint(
        '[ManifestStackInstaller] RinneGraph database creation error: $e',
      );
      // Fallback: create empty file
      final dbFile = File(dbPath);
      await dbFile.create();
      debugPrint(
        '[ManifestStackInstaller] Fallback: created empty database file: $dbPath',
      );
    }
  }

  /// Check existing stack directory structure and complement missing parts
  Future<void> _ensureStackStructure(Directory stackDir) async {
    debugPrint(
      '[ManifestStackInstaller] Starting check and complement of existing stack structure: ${stackDir.path}',
    );

    // Check meta directory
    final metaDir = Directory(path.join(stackDir.path, 'meta'));
    if (!await metaDir.exists()) {
      debugPrint(
        '[ManifestStackInstaller] Creating meta directory: ${metaDir.path}',
      );
      await metaDir.create();
    }

    // Check data directory
    final dataDir = Directory(path.join(stackDir.path, 'data'));
    if (!await dataDir.exists()) {
      debugPrint(
        '[ManifestStackInstaller] Creating data directory: ${dataDir.path}',
      );
      await dataDir.create();
    }

    // Check RinneGraph database file
    final dbFile = File(path.join(stackDir.path, 'data', 'graph.db'));
    if (!await dbFile.exists()) {
      debugPrint(
        '[ManifestStackInstaller] Creating RinneGraph database: ${dbFile.path}',
      );
      await _createGraphDatabase(stackDir);
    }

    debugPrint(
      '[ManifestStackInstaller] Completed check and complement of existing stack structure: ${stackDir.path}',
    );
  }

  /// Import data files to RinneGraph database
  Future<void> _importDataToDatabase(
    Directory stackDir,
    Map<String, dynamic> manifest,
    String templateAssetPath,
  ) async {
    try {
      final dbPath = path.join(stackDir.path, 'data', 'graph.db');
      debugPrint('[ManifestStackInstaller] Database path: $dbPath');

      // Initialize RinneGraphStorage
      final storage = RinneGraphStorage(dbPath);
      await storage.initialize();
      debugPrint(
        '[ManifestStackInstaller] RinneGraphStorage initialization completed',
      );

      // Load schema if exists
      SchemaDefinition? schema;
      try {
        final schemaFileName = manifest['schema'] as String? ?? 'schema.json';
        final schemaAssetPath = '$templateAssetPath/$schemaFileName';
        final schemaContent = await rootBundle.loadString(schemaAssetPath);
        final schemaJson = json.decode(schemaContent) as Map<String, dynamic>;
        schema = SchemaDefinition.fromJson(schemaJson);
        debugPrint('[ManifestStackInstaller] Schema loaded successfully');
      } catch (e) {
        debugPrint(
          '[ManifestStackInstaller] No schema file found or failed to load: $e',
        );
      }

      // Get data file list from manifest
      final files = manifest['files'] as List<dynamic>?;
      if (files == null || files.isEmpty) {
        debugPrint('[ManifestStackInstaller] No data files specified');
        await storage.close();
        return;
      }

      int totalNodes = 0;
      int totalLinks = 0;

      // Process each data file
      for (final fileName in files) {
        final assetPath = '$templateAssetPath/$fileName';
        debugPrint('[ManifestStackInstaller] Processing data file: $assetPath');

        try {
          final fileContent = await rootBundle.loadString(assetPath);
          final data = json.decode(fileContent);

          // If file is in array format (nodes.json, links.json, etc.)
          if (data is List<dynamic>) {
            if (fileName.toLowerCase().contains('node')) {
              // Process node file
              debugPrint(
                '[ManifestStackInstaller] Number of nodes: ${data.length}',
              );
              for (final nodeData in data) {
                await _importNode(
                  storage,
                  nodeData as Map<String, dynamic>,
                  schema,
                );
                totalNodes++;
              }
            } else if (fileName.toLowerCase().contains('link')) {
              // Process link file
              debugPrint(
                '[ManifestStackInstaller] Number of links: ${data.length}',
              );
              for (final linkData in data) {
                await _importLink(
                  storage,
                  linkData as Map<String, dynamic>,
                  schema,
                );
                totalLinks++;
              }
            }
          } else if (data is Map<String, dynamic>) {
            // If file is in object format (legacy format)
            // Process node data
            if (data.containsKey('nodes')) {
              final nodes = data['nodes'] as List<dynamic>;
              debugPrint(
                '[ManifestStackInstaller] Number of nodes: ${nodes.length}',
              );

              for (final nodeData in nodes) {
                await _importNode(
                  storage,
                  nodeData as Map<String, dynamic>,
                  schema,
                );
                totalNodes++;
              }
            }

            // Process link data
            if (data.containsKey('links')) {
              final links = data['links'] as List<dynamic>;
              debugPrint(
                '[ManifestStackInstaller] Number of links: ${links.length}',
              );

              for (final linkData in links) {
                await _importLink(
                  storage,
                  linkData as Map<String, dynamic>,
                  schema,
                );
                totalLinks++;
              }
            }
          }
        } catch (e) {
          debugPrint(
            '[ManifestStackInstaller] Data file processing error ($fileName): $e',
          );
        }
      }

      await storage.close();
      debugPrint(
        '[ManifestStackInstaller] Data import completed: nodes=$totalNodes, links=$totalLinks',
      );

      // Execute validation if validation info exists
      await _validateImportedData(stackDir, manifest, totalNodes, totalLinks);
    } catch (e, stackTrace) {
      debugPrint('[ManifestStackInstaller] Data import error: $e');
      debugPrint('[ManifestStackInstaller] Stack trace: $stackTrace');
    }
  }

  /// Import node to RinneGraph database
  Future<void> _importNode(
    RinneGraphStorage storage,
    Map<String, dynamic> nodeData,
    SchemaDefinition? schema,
  ) async {
    // Process schema references
    final processedNodeData = SchemaProcessor.processNodeData(nodeData, schema);

    final customId = processedNodeData['id'] as String;
    final labels =
        (processedNodeData['labels'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toSet() ??
        <String>{};
    final properties =
        processedNodeData['properties'] as Map<String, dynamic>? ?? {};

    // Create EntityDescription (simplified version)
    const description = EntityDescription(type: 'node', propertyTypes: {});

    await storage.createNode(
      description: description,
      properties: properties,
      labels: labels,
      customId: customId,
    );
  }

  /// Import link to RinneGraph database
  Future<void> _importLink(
    RinneGraphStorage storage,
    Map<String, dynamic> linkData,
    SchemaDefinition? schema,
  ) async {
    try {
      // Process schema references
      final processedLinkData = SchemaProcessor.processLinkData(
        linkData,
        schema,
      );

      final sourceCustomId = processedLinkData['source'] as String;
      final targetCustomId = processedLinkData['target'] as String;
      final type = processedLinkData['type'] as String;
      final properties =
          processedLinkData['properties'] as Map<String, dynamic>? ?? {};

      debugPrint(
        '[ManifestStackInstaller] Starting link processing: $sourceCustomId -> $targetCustomId ($type)',
      );
      debugPrint('[ManifestStackInstaller] Storage: $storage');

      // Get EntityId from custom ID
      final sourceNode = await storage.getNodeByCustomId(sourceCustomId);
      debugPrint(
        '[ManifestStackInstaller] Source node retrieval result: ${sourceNode?.id}',
      );

      final targetNode = await storage.getNodeByCustomId(targetCustomId);
      debugPrint(
        '[ManifestStackInstaller] Target node retrieval result: ${targetNode?.id}',
      );

      if (sourceNode == null || targetNode == null) {
        debugPrint(
          '[ManifestStackInstaller] Link creation failed: node not found (source: $sourceCustomId, target: $targetCustomId)',
        );
        return;
      }

      // Create EntityDescription (simplified version)
      const description = EntityDescription(type: 'link', propertyTypes: {});

      debugPrint(
        '[ManifestStackInstaller] Starting link creation: ${sourceNode.id} -> ${targetNode.id}',
      );
      await storage.createLink(
        sourceId: sourceNode.id,
        targetId: targetNode.id,
        type: type,
        description: description,
        properties: properties,
      );
      debugPrint('[ManifestStackInstaller] Link creation successful: $type');
    } on Exception catch (e, stackTrace) {
      debugPrint('[ManifestStackInstaller] Link import error: $e');
      debugPrint('[ManifestStackInstaller] Link data: $linkData');
      debugPrint('[ManifestStackInstaller] Stack trace: $stackTrace');
    }
  }

  /// Validate imported data
  Future<void> _validateImportedData(
    Directory stackDir,
    Map<String, dynamic> manifest,
    int actualNodes,
    int actualLinks,
  ) async {
    final metadata = manifest['metadata'] as Map<String, dynamic>?;
    final validation = metadata?['validation'] as Map<String, dynamic>?;

    if (validation == null) {
      debugPrint(
        '[ManifestStackInstaller] No validation info - skipping validation',
      );
      return;
    }

    debugPrint('[ManifestStackInstaller] Starting data validation');

    final expectedNodes = validation['expected_node_count'] as int?;
    final expectedLinks = validation['expected_link_count'] as int?;
    final strictMode = validation['strict_mode'] as bool? ?? false;

    bool validationPassed = true;

    // Validate node count
    if (expectedNodes != null) {
      if (actualNodes == expectedNodes) {
        debugPrint(
          '[ManifestStackInstaller] Node count validation: expected $expectedNodes, actual $actualNodes ✓',
        );
      } else {
        debugPrint(
          '[ManifestStackInstaller] Node count validation: expected $expectedNodes, actual $actualNodes ✗',
        );
        validationPassed = false;
      }
    }

    // Validate link count
    if (expectedLinks != null) {
      if (actualLinks == expectedLinks) {
        debugPrint(
          '[ManifestStackInstaller] Link count validation: expected $expectedLinks, actual $actualLinks ✓',
        );
      } else {
        debugPrint(
          '[ManifestStackInstaller] Link count validation: expected $expectedLinks, actual $actualLinks ✗',
        );
        validationPassed = false;
      }
    }

    if (validationPassed) {
      debugPrint(
        '[ManifestStackInstaller] Data validation completed: all validation items passed',
      );
    } else {
      final message =
          '[ManifestStackInstaller] Data validation failed: expected and actual values do not match';
      if (strictMode) {
        throw Exception(message);
      } else {
        debugPrint('$message (continuing as warning)');
      }
    }
  }

  /// Process thumbnail image (if exists)
  Future<void> _processThumbnailImage(
    String templateAssetPath,
    Directory stackDir,
    Map<String, dynamic> manifest,
  ) async {
    try {
      // Get thumbnail info from manifest
      final metadata = manifest['metadata'] as Map<String, dynamic>?;
      final thumbnailFileName = metadata?['thumbnail'] as String?;

      if (thumbnailFileName == null || thumbnailFileName.isEmpty) {
        debugPrint('[ManifestStackInstaller] No thumbnail image specified');
        return;
      }

      // Build thumbnail image path in template assets
      final thumbnailAssetPath = '$templateAssetPath/meta/$thumbnailFileName';

      // Load thumbnail image from assets
      try {
        final thumbnailData = await rootBundle.load(thumbnailAssetPath);

        // Ensure output meta/ directory
        final metaDir = Directory(path.join(stackDir.path, 'meta'));
        if (!await metaDir.exists()) {
          await metaDir.create(recursive: true);
        }

        // Create thumbnail image file
        final outputThumbnailPath = path.join(metaDir.path, thumbnailFileName);
        final outputFile = File(outputThumbnailPath);

        // Write binary data
        final bytes = thumbnailData.buffer.asUint8List();
        await outputFile.writeAsBytes(bytes);

        debugPrint(
          '[ManifestStackInstaller] Copied thumbnail image: $outputThumbnailPath',
        );
      } catch (e) {
        debugPrint(
          '[ManifestStackInstaller] Failed to load thumbnail image: $thumbnailAssetPath ($e)',
        );
        // Continue stack creation even if thumbnail processing fails
      }
    } catch (e) {
      debugPrint(
        '[ManifestStackInstaller] Thumbnail image processing error: $e',
      );
      // Continue stack creation even if thumbnail processing fails
    }
  }
}
