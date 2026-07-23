/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/model/entity_description.dart';

/// Provides the fixed ChiffonDB meta-schema used to represent RinneGraph's
/// schemaless property graph.
///
/// RinneGraph stacks are schemaless: users add labels, edge types, and
/// arbitrary properties at runtime. ChiffonDB, by contrast, is schema-enforced.
/// Rather than mapping user types onto ChiffonDB types (which would rewrite the
/// ChiffonDB schema every time a user changes their data model), we keep a
/// single fixed meta-schema and represent the user's graph on top of it — the
/// way Notion/FileMaker store user-defined databases on fixed tables.
///
/// Mapping:
///   - Every node is inserted as `_Entity`; the user's labels (Person, Event…)
///     are attached as ChiffonDB *dynamic labels* (`insertNodeWithDynamicLabels`),
///     which are minted on the fly without a schema migration.
///   - Every edge is inserted as `_Link`; the user's edge type
///     (PARTICIPATED_IN…) is attached as a dynamic edge label and also stored in
///     the `app_type` property.
///   - The user's arbitrary properties live under a single `props: Json` field,
///     so no schema change is needed when a user adds a property. Keyword search
///     works because ChiffonDB's `any_key_contains` recurses into Json values.
class ChiffonSchemaGenerator {
  /// The fixed meta-schema. Applied once when a database is created; it never
  /// changes as the user edits their graph.
  static const String minimalSchema = '''
node _Entity {
    app_id: String
    app_custom_id: String
    app_type: String
    app_created_at: Int
    app_updated_at: Int
    props: Json
}
edge _Link {
    from: _Entity
    to: _Entity
    props: {
        app_id: String
        app_custom_id: String
        app_type: String
        app_source_id: String
        app_target_id: String
        app_created_at: Int
        app_updated_at: Int
        props: Json
    }
}
''';

  /// Returns the fixed meta-schema.
  ///
  /// User node/edge descriptions no longer produce ChiffonDB types — they are
  /// represented as data on top of the meta-schema — so the descriptions are
  /// ignored and the same fixed schema is always returned. The parameters are
  /// retained for source compatibility with existing callers.
  static String generate({
    List<EntityDescription> nodeDescriptions = const [],
    List<EntityDescription> edgeDescriptions = const [],
  }) => minimalSchema;
}
