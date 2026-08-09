/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:characters/characters.dart';
import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:meta/meta.dart';

/// Abstract class representing property type
///
/// This class defines the type of properties in a graph database.
/// Each property type must provide the following functionality:
/// - Type name
/// - Value validation
/// - Value conversion
/// - UI display hints
@immutable
abstract class PropertyType {
  const PropertyType({required this.name, this.isRequired = false});

  /// Type name
  final String name;

  /// Whether required
  final bool isRequired;

  /// Determine if value is valid for this type
  bool isValid(dynamic value);

  /// Convert value to this type
  dynamic convertValue(dynamic value);

  /// Convert type to map
  Map<String, dynamic> toMap() => {'name': name, 'isRequired': isRequired};

  /// Validate value
  ///
  /// [value] Value to validate
  ///
  /// Validates whether value meets type constraints.
  /// Null is always treated as a valid value.
  ValidationResult validate(dynamic value);

  /// Type-specific value validation
  ///
  /// [value] Value to validate (non-null)
  ///
  /// Must be implemented in subclasses.
  @protected
  bool validateValue(dynamic value);

  /// Convert value
  ///
  /// [value] Value to convert
  ///
  /// Converts value to appropriate type.
  /// Returns null if conversion is not possible.
  dynamic convert(dynamic value) {
    if (value == null) return null;
    return convertValue(value);
  }

  @override
  String toString() => 'PropertyType($name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PropertyType &&
        other.runtimeType == runtimeType &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);
}

/// String type
class TextPropertyType extends PropertyType {
  /// Constructor
  const TextPropertyType({
    super.isRequired = false,
    this.minLength,
    this.maxLength,
    this.pattern,
  }) : super(name: 'text');

  /// Minimum length
  final int? minLength;

  /// Maximum length
  final int? maxLength;

  /// Pattern (regular expression)
  final String? pattern;

  @override
  bool isValid(dynamic value) {
    if (value is! String) return false;
    if (minLength != null && value.length < minLength!) return false;
    if (maxLength != null && value.length > maxLength!) return false;
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! String) {
      return const ValidationResult.error('Value must be a string');
    }
    if (minLength != null && value.length < minLength!) {
      return ValidationResult.error(
        'Value must be at least $minLength characters',
      );
    }
    if (maxLength != null && value.length > maxLength!) {
      return ValidationResult.error(
        'Value must be at most $maxLength characters',
      );
    }
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return const ValidationResult.error(
        'Value must match the specified pattern',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  String? convertValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}

/// Integer type
class IntegerPropertyType extends PropertyType {
  /// Constructor
  const IntegerPropertyType({super.isRequired = false, this.min, this.max})
    : super(name: 'integer');

  /// Minimum value
  final int? min;

  /// Maximum value
  final int? max;

  @override
  bool isValid(dynamic value) {
    if (value is! int) return false;
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! int) {
      return const ValidationResult.error('Value must be an integer');
    }
    if (min != null && value < min!) {
      return ValidationResult.error('Value must be at least $min');
    }
    if (max != null && value > max!) {
      return ValidationResult.error('Value must be at most $max');
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  int? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

/// Floating-point number type
class DecimalPropertyType extends PropertyType {
  /// Constructor
  const DecimalPropertyType({super.isRequired = false, this.min, this.max})
    : super(name: 'decimal');

  /// Minimum value
  final double? min;

  /// Maximum value
  final double? max;

  @override
  bool isValid(dynamic value) {
    if (value is! double) return false;
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! double) {
      return const ValidationResult.error('Value must be a decimal');
    }
    if (min != null && value < min!) {
      return ValidationResult.error('Value must be at least $min');
    }
    if (max != null && value > max!) {
      return ValidationResult.error('Value must be at most $max');
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  double? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

/// Boolean type
class BooleanPropertyType extends PropertyType {
  /// Constructor
  const BooleanPropertyType({super.isRequired = false})
    : super(name: 'boolean');

  @override
  bool isValid(dynamic value) => value is bool;

  @override
  ValidationResult validate(dynamic value) {
    if (value is! bool) {
      return const ValidationResult.error('Value must be a boolean');
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  bool? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
    }
    return null;
  }
}

/// Date/time type
class DatePropertyType extends PropertyType {
  /// Constructor
  const DatePropertyType({super.isRequired = false, this.min, this.max})
    : super(name: 'date');

  /// Minimum value
  final DateTime? min;

  /// Maximum value
  final DateTime? max;

  @override
  bool isValid(dynamic value) {
    if (value is! DateTime) return false;
    if (min != null && value.isBefore(min!)) return false;
    if (max != null && value.isAfter(max!)) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! DateTime) {
      return const ValidationResult.error('Value must be a date');
    }
    if (min != null && value.isBefore(min!)) {
      return ValidationResult.error(
        'Value must be on or after ${min!.toIso8601String()}',
      );
    }
    if (max != null && value.isAfter(max!)) {
      return ValidationResult.error(
        'Value must be on or before ${max!.toIso8601String()}',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  DateTime? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

/// Email address type
class EmailPropertyType extends PropertyType {
  /// Constructor
  const EmailPropertyType({super.isRequired = false}) : super(name: 'email');

  @override
  bool isValid(dynamic value) {
    if (value is! String) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! String) {
      return const ValidationResult.error('Value must be a string');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return const ValidationResult.error(
        'Value must be a valid email address',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  String? convertValue(dynamic value) {
    if (value == null) return null;
    final strValue = value.toString();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(strValue) ? strValue : null;
  }
}

/// Other types
class AnyPropertyType extends PropertyType {
  /// Constructor
  const AnyPropertyType({super.isRequired = false}) : super(name: 'any');

  @override
  bool isValid(dynamic value) => true;

  @override
  ValidationResult validate(dynamic value) {
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return true;
  }

  @override
  dynamic convertValue(dynamic value) => value;
}

/// A short block of prose attached to an entity — a note, not a document.
///
/// Deliberately a separate type rather than [TextPropertyType] with a
/// "multiline" hint, for two reasons:
///
///  * The type picker has to offer "Memo" as its own choice. A user adding a
///    property should not have to know to pick "text" and then find a flag.
///  * The length limit below is part of the type, not a per-property setting.
///
/// The limit is a design position, not a storage constraint: nothing in
/// ChiffonDB cares how long the string is (user properties all live in one
/// `props: Json` field). It exists to say "if it no longer fits, split the
/// node" — the graph is the structure, not the prose. Keeping it modest also
/// matters in the other direction: a limit tight enough to be annoying would
/// just push people to the unlimited [TextPropertyType], which would defeat
/// the point entirely.
class MemoPropertyType extends PropertyType {
  /// Constructor
  const MemoPropertyType({super.isRequired = false}) : super(name: 'memo');

  /// The largest memo we accept, in user-visible characters.
  ///
  /// Fixed rather than configurable: a limit anyone can raise to 10000 is not
  /// a limit. Matches the existing `description` definition in
  /// GlobalPropertyTypeManager, which also caps at 500.
  static const int maxLength = 500;

  /// Where the counter stops being invisible and starts nudging.
  ///
  /// Below this the field says nothing; above it, the remaining count is shown
  /// so the limit arrives as a gradient rather than a wall.
  static const int counterThreshold = 200;

  /// Counts [value] the way a reader would.
  ///
  /// Grapheme clusters, not UTF-16 code units: an emoji or a combining
  /// sequence is one character to the person typing it, so it is one here too.
  /// This is why the field cannot use Flutter's `maxLength`, which counts code
  /// units — 500 there would cut a text of emoji off at 250.
  static int lengthOf(String value) => value.characters.length;

  @override
  bool isValid(dynamic value) {
    if (value is! String) return false;
    return lengthOf(value) <= maxLength;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! String) {
      return const ValidationResult.error('Value must be a string');
    }
    final length = lengthOf(value);
    if (length > maxLength) {
      return ValidationResult.error(
        'Memo must be at most $maxLength characters (currently $length). '
        'Consider splitting this into separate nodes.',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  String? convertValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}

/// What a link points at, derived from the URI rather than stored alongside it.
enum LinkKind {
  /// A file carried inside the stack directory, addressed as
  /// `rinne://stack/<path>`.
  ///
  /// Travels with the stack when it is copied, so it survives being moved to
  /// another machine.
  stackRelative,

  /// A file outside the stack, addressed as `file:///…`.
  ///
  /// An absolute path, so it breaks if the stack moves to another machine.
  /// Resolving these through a named base is a later step.
  externalFile,

  /// Anything with another scheme — `https:`, `obsidian:`, `notion:`.
  url,
}

/// A reference to content that lives outside the graph.
///
/// Where [MemoPropertyType] holds a short note *in* the graph, this holds a
/// pointer to the real thing: a Markdown file in an Obsidian vault, a Notion
/// page, a PDF on disk. It is what makes the memo limit tenable — past 500
/// characters the answer is no longer only "split the node", it can be "put the
/// body outside and link to it".
///
/// The value is a single URI string, not a structured record, for two reasons:
///
///  * Property values are scalars everywhere else in the system, and staying
///    scalar keeps this type working with the existing storage, search and
///    validation paths untouched.
///  * The three kinds a user distinguishes ([LinkKind]) are all derivable from
///    the string, so the kind never has to be stored — and can never disagree
///    with the value it describes.
///
/// The contents of the target are deliberately not indexed. Keeping an external
/// file's text searchable would mean watching it for edits made in other
/// applications, which cannot be done reliably while this app is not running.
/// The URI itself is ordinary text, so filename, host and path still match in
/// a search.
class LinkPropertyType extends PropertyType {
  /// Constructor
  const LinkPropertyType({super.isRequired = false, this.defaultKind})
    : super(name: 'link');

  /// Which kind of link this property was created to hold.
  ///
  /// Only consulted while the value is empty: a link that holds something is
  /// classified by [kindOf], which can never disagree with the value. This
  /// exists because the picker offers the three kinds as separate choices, and
  /// a property added as "External file" has to open on a file input rather
  /// than defaulting to a URL.
  ///
  /// Null means no preference was recorded — an older definition, or one
  /// written by the command with a bare `link` type.
  final LinkKind? defaultKind;

  /// The constraint key [defaultKind] is persisted under.
  static const String defaultKindConstraint = 'default_kind';

  /// Reads [defaultKind] back out of a definition's constraints.
  ///
  /// An unrecognized name yields null rather than throwing, so a definition
  /// written by a newer build degrades to "no preference".
  static LinkKind? kindFromName(Object? name) {
    if (name is! String) return null;
    for (final kind in LinkKind.values) {
      if (kind.name == name) return kind;
    }
    return null;
  }

  /// Scheme identifying a link relative to something RinneGraph knows about.
  static const String rinneScheme = 'rinne';

  /// The reserved host meaning "this stack's own directory".
  ///
  /// Named bases (an Obsidian vault, a projects folder) will occupy the same
  /// position later; `stack` is reserved now so those cannot collide with it.
  static const String stackHost = 'stack';

  /// Classifies [value], or returns null if it is not a usable link.
  static LinkKind? kindOf(String value) {
    final uri = _tryParse(value);
    if (uri == null) return null;

    if (uri.scheme == rinneScheme) {
      return uri.host == stackHost ? LinkKind.stackRelative : null;
    }
    if (uri.scheme == 'file') return LinkKind.externalFile;
    if (uri.scheme.isEmpty) return null;
    return LinkKind.url;
  }

  /// Puts user input into the stored form, or returns null if it cannot.
  ///
  /// Accepts a bare absolute path — typing or pasting `/Users/me/note.md` is
  /// natural, and a file picker hands back exactly that — and stores it as a
  /// `file://` URI so that everything downstream sees one shape.
  static String? normalize(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    if (trimmed.startsWith('/')) {
      return Uri.file(trimmed).toString();
    }

    final uri = _tryParse(trimmed);
    if (uri == null || !uri.hasScheme) return null;
    return uri.toString();
  }

  /// The part of [value] worth showing in a list, falling back to the whole
  /// URI when nothing shorter is meaningful.
  ///
  /// A link is usually recognised by its last path segment — the filename or
  /// the page slug — and the full URI is too long to sit in a property row.
  static String displayLabel(String value) {
    final uri = _tryParse(value);
    if (uri == null) return value;

    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isNotEmpty) return Uri.decodeComponent(segments.last);
    if (uri.host.isNotEmpty) return uri.host;
    return value;
  }

  /// The path within the stack directory for a [LinkKind.stackRelative] link.
  ///
  /// Returns null for every other kind, so callers resolving against a stack
  /// directory cannot accidentally treat an external link as a relative one.
  static String? stackRelativePath(String value) {
    final uri = _tryParse(value);
    if (uri == null) return null;
    if (uri.scheme != rinneScheme || uri.host != stackHost) return null;

    // Decoded, so a filename stored with an escaped space comes back as the
    // name the file actually has.
    return uri.pathSegments.where((segment) => segment.isNotEmpty).join('/');
  }

  /// The value as a person would write it, with the scheme machinery removed.
  ///
  /// `file:///Users/me/note.md` becomes `/Users/me/note.md` and
  /// `rinne://stack/notes/design.md` becomes `notes/design.md`. A URL is left
  /// alone: `https://` is part of how anyone reads a web address, unlike the
  /// two schemes above, which exist only so the value can be stored in one
  /// field.
  ///
  /// This is the form the editor puts in front of the user, and
  /// [normalizeForKind] turns it back.
  static String editableForm(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';

    switch (kindOf(trimmed)) {
      case LinkKind.stackRelative:
        return stackRelativePath(trimmed) ?? trimmed;
      case LinkKind.externalFile:
        final uri = _tryParse(trimmed);
        if (uri == null) return trimmed;
        try {
          return uri.toFilePath();
        } on UnsupportedError {
          return trimmed;
        }
      case LinkKind.url:
      case null:
        return trimmed;
    }
  }

  /// Turns [input] typed under [kind] back into the stored form.
  ///
  /// The inverse of [editableForm]: a bare path means different things
  /// depending on the kind it was entered under, which is why the kind has to
  /// be supplied rather than guessed.
  static String normalizeForKind(String input, LinkKind kind) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '';

    switch (kind) {
      case LinkKind.stackRelative:
        return stackRelativeUri(trimmed);
      case LinkKind.externalFile:
      case LinkKind.url:
        return normalize(trimmed) ?? trimmed;
    }
  }

  /// Expresses [absolutePath] relative to [stackPath], or null if it is not
  /// inside it.
  ///
  /// Guards the promise a stack-relative link makes: that the target travels
  /// with the stack. A file outside the stack directory cannot keep that
  /// promise, so it is refused here rather than stored as an absolute path
  /// under a kind that says otherwise.
  static String? relativeToStack(String absolutePath, String? stackPath) {
    if (stackPath == null || stackPath.isEmpty) return null;

    final root = stackPath.endsWith('/') ? stackPath : '$stackPath/';
    if (!absolutePath.startsWith(root)) return null;

    final relative = absolutePath.substring(root.length);
    return relative.isEmpty ? null : relative;
  }

  /// Builds the stored form of a link to [relativePath] inside the stack.
  ///
  /// Percent-encodes each segment, so a filename with a space or a `#` in it
  /// survives the round trip through [stackRelativePath].
  static String stackRelativeUri(String relativePath) {
    final trimmed = relativePath.trim();
    final path = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return Uri(
      scheme: rinneScheme,
      host: stackHost,
      pathSegments: path.split('/'),
    ).toString();
  }

  /// Parses [value], treating a malformed URI as absent rather than throwing.
  static Uri? _tryParse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return Uri.tryParse(trimmed);
  }

  @override
  bool isValid(dynamic value) {
    if (value is! String) return false;
    // An empty value is a property that has not been filled in yet, which the
    // editor must be able to save — the same latitude every other type gives.
    if (value.trim().isEmpty) return true;
    return kindOf(value) != null;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! String) {
      return const ValidationResult.error('Value must be a string');
    }
    if (value.trim().isEmpty) return ValidationResult.success;
    if (kindOf(value) == null) {
      return const ValidationResult.error(
        'Value must be a URL, a file path, or a location inside this stack',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  String? convertValue(dynamic value) {
    if (value == null) return null;
    return normalize(value.toString()) ?? value.toString();
  }
}
