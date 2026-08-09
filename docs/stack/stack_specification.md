# Stack Specification

## 1. Overview

A Stack is the fundamental unit for managing user data in RinneGraph, separated by purpose. It functions as a personal database that can be used for various purposes such as project management, knowledge bases, and research data.

### 1.1 Types of Stacks

-   **Normal Stack**: A persistent database created and managed by the user.
-   **Scratch Stack**: A temporary working database.
-   **Sample Stack**: An editable instance generated from a built-in template at app startup. Stored in the `Samples/` directory.
-   **Asset-based Stack**: A sample database generated from read-only templates.

### 1.2 Technical Foundation

-   **Database**: RinneGraph (embedded graph database)
-   **Storage**: SQLite file (one per stack)
-   **Metadata**: Settings and basic information managed in JSON format
-   **File Format**: Directory format, with a `.stack` extension

## 2. Directory Structure

### 2.1 Basic Structure

```
my_stack.stack/
├── meta/                         # Metadata directory
│   ├── info.json                 # Stack basic information
│   ├── settings.json             # Stack settings
│   └── thumbnail.png             # Thumbnail image (optional)
├── data/                         # Data directory
│   └── graph.db                  # RinneGraph's SQLite database
├── datasets/                     # Dataset definitions (subgraph management)
│   ├── [dataset-id].json         # Individual dataset settings
│   └── ...
├── assets/                       # Binary assets (user data)
│   ├── [asset-id]/               # Directory per asset
│   │   ├── data                  # Actual data
│   │   └── meta.json             # Metadata
│   └── ...
└── filters/                      # Filter definitions (saved search conditions)
    ├── [filter-id].json          # Individual filter settings
    └── ...
```

### 2.2 Stack Identification

A stack is identified by the following conditions:
- The directory name ends with a `.stack` extension.
- The `meta/info.json` file exists.

## 3. Metadata Specification

### 3.1 meta/info.json

This is a JSON file containing basic information about the stack.

```json
{
  "name": "Project A",
  "description": "Database related to Project A",
  "author": "Username",
  "thumbnail": "thumbnail.png",
  "createdAt": "2025-03-15T10:30:00Z",
  "lastModifiedAt": "2025-04-21T14:45:00Z",
  "version": "1.0",
  "tags": ["Project", "Business"]
}
```

#### Required Fields
- `name`: Stack name (string)
- `createdAt`: Creation timestamp (ISO 8601 format)
- `lastModifiedAt`: Last modified timestamp (ISO 8601 format)
- `version`: Version (string)

#### Optional Fields
- `description`: Description (string)
- `author`: Author (string)
- `thumbnail`: Thumbnail image filename (string)
- `tags`: Array of tags (array of strings)
- `isSample`: Whether this stack is a sample stack instance (boolean, default `false`)
- `sampleTemplateId`: The template ID used to generate this sample stack (string, only present when `isSample` is `true`)
- `language`: Language of the stack content (ISO 639-1 code, e.g. `"en"`, `"ja"`). Used for filtering stacks on the welcome screen.

### 3.2 meta/settings.json

This is a JSON file containing stack-specific settings.

```json
{
  "defaultView": "graph",
  "autoBackupEnabled": true,
  "autoBackupInterval": 86400,
  "customFields": {
    "isPinned": true,
    "category": "work",
    "priority": "high"
  }
}
```

#### Standard Settings Fields
- `defaultView`: Default view ("graph", "table", "outline")
- `autoBackupEnabled`: Auto backup enabled (boolean)
- `autoBackupInterval`: Auto backup interval (seconds)
- `customFields`: Custom fields (object)

### 3.3 Thumbnail Image Specification

It is recommended to create thumbnail images according to the following specifications:

-   **File Format**: PNG or JPEG recommended
-   **Recommended Size**: 1280px × 720px or larger
-   **Aspect Ratio**: 16:9 strongly recommended
-   **Display Rules**: The application will display the image cropped to fit the display area while maintaining its center (equivalent to `object-fit: cover`)
-   **Design Guidelines**: It is strongly recommended to place important elements within a 1:1 area in the center of the image.
-   **File Name**: `thumbnail.png` or `thumbnail.jpg` recommended
-   **Location**: Inside the `meta/` directory
-   **Local Files Only**: Only local files within the stack are supported (network URLs are not allowed)

#### Error Handling
- If file does not exist: Output warning to log and display default icon
- If invalid file format: Output warning to log and process without thumbnail
- If thumbnail not set: Display default icon or auto-generated preview

## 4. Data Management

### 4.1 Graph Database

-   **Engine**: RinneGraph (Gremlin-like API)
-   **Storage**: SQLite file (`data/graph.db`)
-   **Data Model**: Property Graph
-   **System Properties**: Use "_" prefix

### 4.2 Binary Assets

-   **Location**: `assets/` directory
-   **Structure**: Subdirectory per asset ID
-   **Metadata**: `meta.json` manages MIME types, etc.
-   **Actual Data**: `data` file (no extension)

### 4.3 Datasets (Subgraphs)

Datasets are a mechanism for logically dividing and managing large graphs.

```json
{
  "id": "important-docs",
  "name": "Important Documents",
  "description": "Collection of high-priority documents",
  "isActive": true,
  "color": "#FF5722",
  "tags": ["important", "documents"],
  "filter": {
    "entityLabels": ["Document"],
    "properties": {
      "priority": ["high", "urgent"],
      "status": ["active"]
    }
  },
  "statistics": {
    "nodeCount": 150,
    "linkCount": 89,
    "lastComputed": "2025-04-21T14:45:00Z"
  }
}
```

## 5. Current Implementation Status

### 5.1 Implemented Features

-   ✅ Stack detection, creation, deletion
-   ✅ Metadata management (info.json, settings.json)
-   ✅ Basic dataset operations
-   ✅ Riverpod provider integration
-   ✅ Asset-based stacks (samples)
-   ✅ Sample stacks (pre-instantiated from templates at startup)
-   ✅ Scratch stacks (temporary work)
-   ✅ Thumbnail image support

### 5.2 Partially Implemented / Under Consideration

-   🔄 Binary asset management (basic structure only)
-   🔄 Filter function (basic structure only)
-   🔄 Automatic backup function
-   🔄 Stack statistics

### 5.3 Future Extensions Planned

-   📋 Inter-stack data migration
-   📋 Stack templating function
-   📋 Stack compression and archiving
-   📋 Cloud synchronization support
-   📋 Stack sharing function
-   📋 Automatic thumbnail generation

## 5.4 Link URI Scheme

The `link` property type stores a single URI string pointing at content that
lives outside the graph — a Markdown file in an Obsidian vault, a Notion page,
a PDF on disk. This exists because RinneGraph is not meant to hold everything:
past the `memo` type's 500-character limit, the answer is either to split the
node or to keep the body in a dedicated tool and reference it from here.

### 5.4.1 Recognized Forms

| Form | Example | Meaning |
|---|---|---|
| `rinne://stack/<path>` | `rinne://stack/notes/design.md` | A file inside this stack's directory |
| `file://<absolute path>` | `file:///Users/me/note.md` | A file outside the stack |
| Any other scheme | `https://…`, `obsidian://…` | A URL, opened by the OS |

The kind is always derived from the URI, never stored beside it, so the two
cannot disagree. A bare absolute path entered by the user is normalized to
`file://` on the way in.

### 5.4.1.1 One Stored Type, Three Offered Types

`link` is a single persisted type name, but it is **not** presented as one.
The property type picker offers "URL", "External file" and "File in this
stack" as three separate choices, because that is what someone attaching
something actually has in mind — nobody thinks "I want a link, of the URL
variety". Grouping them under one "Link" entry would expose the storage design
as a decision the user has to make.

The three choices differ only in which input the editor opens on. The stored
value is a URI in every case, and its kind is read back off the value, so a
property created as "URL" that later holds a `file://` value simply presents
as a file.

The chosen variant is recorded as a `default_kind` **constraint** on the type
definition:

```json
{ "type": "link", "constraints": { "default_kind": "externalFile" } }
```

It is a constraint rather than a UI hint because only constraints survive the
trip back out — a resolved property type is rebuilt from them and everything
else is dropped. It decides nothing about validity: a link that holds a value
is classified by the value, and this only gives a still-empty property a
sensible starting input. A definition with no `default_kind`, or with one this
build does not recognize, simply has no preference.

The `record_editor.property.add` command accepts either form: a bare `link`,
or one of `link:url`, `link:externalFile`, `link:stackRelative`.

### 5.4.2 The `rinne` Scheme

`rinne://` addresses a location RinneGraph knows how to resolve. The host names
that location; `stack` is reserved for the stack's own directory and is
currently the only recognized host. A `rinne://` URI with an unknown host is
refused rather than guessed at, so a link written by a future version cannot be
silently opened as the wrong thing.

Reserving the host position now is what allows named bases to be added later —
`rinne://obsidian-vault/notes/design.md`, where `obsidian-vault` resolves to a
per-machine absolute path held outside the stack. That indirection is the
answer to external file paths breaking when a stack moves between machines, and
is deliberately not implemented yet: external files are stored as absolute
paths for now.

### 5.4.3 What Is Not Indexed

The contents of a link target are not searched. Keeping an external file's text
searchable would require watching it for edits made in other applications,
which cannot be done reliably while RinneGraph is not running, and would mean
parsing arbitrary formats. The URI itself is ordinary text, so filenames, hosts
and paths still match in a search.

Link targets are also not checked for existence while rendering — only when the
user opens one. A property row would otherwise touch the filesystem on every
rebuild, and a link on a network volume would stall the editor.

## 6. Design Principles

### 6.1 Data Transparency and Portability

-   Metadata and settings are stored in JSON format, allowing viewing and editing without special tools.
-   The simple directory structure facilitates easy copying and moving of entire stacks.
-   Clear separation of binary data (`assets/`) and graph data (`data/graph.db`).

### 6.2 Extensibility

-   Clearly separated directory structure facilitates future feature additions.
-   Leaves room for future schema definitions and text store introductions.

### 6.3 Performance

-   **Database Size**: Limited to the maximum size of one SQLite file.
-   **Record Count**: Approximately 50,000 records as a guideline.
-   **Concurrent Access**: 1 user (1 concurrent access).
-   **Memory Management**: Memory usage suppressed for general users.

## 7. Related Specifications

-   [Stack Exchange Format Specification](stack_exchange_format_specification.md) - Import/Export format
-   [Stack Import Options Specification](stack_import_options_specification.md) - Detailed import settings

## 8. Implementation Packages

-   **core_stack**: Core package for stack management
-   **core_graph**: Graph database (RinneGraph) integration
-   **core_foundation**: Basic utilities