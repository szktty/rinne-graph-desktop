/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Core graph database functionality (Pure Dart, no Flutter dependencies)
///
/// This package provides basic graph database functionality in Pure Dart.
/// It can also be used in CLI applications.
library;

// Export core models
export 'src/model/entity.dart';
export 'src/model/entity_description.dart';
export 'src/model/entity_id.dart';
export 'src/model/entity_kind.dart';
export 'src/model/graph.dart';
export 'src/model/graph_statistics.dart';
export 'src/model/link.dart';
export 'src/model/node.dart';
export 'src/model/property.dart';
export 'src/model/property_description.dart';
export 'src/model/property_set.dart';
export 'src/model/property_type.dart';
export 'src/model/property_value_transformer.dart';
export 'src/model/property_value_validator.dart';

// Export context
export 'src/context/graph_context.dart';
export 'src/context/transaction_context.dart';

// Export query system
export 'src/query/graph_query.dart';
export 'src/query/predicate.dart';
export 'src/query/sort_descriptor.dart';
export 'src/query/chiffon_query_converter.dart';

// Export storage
export 'src/storage/graph_storage.dart';
export 'src/storage/in_memory_graph_storage.dart';
export 'src/storage/chiffon_storage.dart';
export 'src/storage/chiffon_transaction.dart';
export 'src/storage/chiffon_schema_generator.dart';

// Export metadata management
export 'src/metadata/label_metadata.dart';
export 'src/metadata/label_storage.dart';

// Export global property type system
export 'src/property_type/index.dart';

// Export database utilities
export 'src/utils/database_creator.dart';
export 'src/utils/database_validator.dart';

// Export basic models (Pure Dart only)
export 'src/models/database_validation_result.dart';
export 'src/models/database_creation_result.dart';

// Export exceptions
export 'src/exceptions/database_exceptions.dart';
