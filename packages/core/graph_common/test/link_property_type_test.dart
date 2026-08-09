/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:test/test.dart';
// Prefixed because core_graph_common's query predicates export names that
// collide with matcher's (`contains`, `isNull`).
import 'package:core_graph_common/core_graph_common.dart' as graph;

void main() {
  group('LinkPropertyType', () {
    const type = graph.LinkPropertyType();

    group('kindOf', () {
      test('classifies a stack-relative link', () {
        expect(
          graph.LinkPropertyType.kindOf('rinne://stack/notes/design.md'),
          graph.LinkKind.stackRelative,
        );
      });

      test('classifies an external file', () {
        expect(
          graph.LinkPropertyType.kindOf('file:///Users/me/note.md'),
          graph.LinkKind.externalFile,
        );
      });

      test('classifies http and https as URLs', () {
        expect(
          graph.LinkPropertyType.kindOf('https://notion.so/a-page'),
          graph.LinkKind.url,
        );
        expect(
          graph.LinkPropertyType.kindOf('http://example.com'),
          graph.LinkKind.url,
        );
      });

      // The whole point of linking out: an app-specific scheme has to survive
      // untouched, since that is how Obsidian and friends are addressed.
      test('classifies an application scheme as a URL', () {
        expect(
          graph.LinkPropertyType.kindOf(
            'obsidian://open?vault=Main&file=notes%2Fdesign',
          ),
          graph.LinkKind.url,
        );
      });

      // The rinne scheme is reserved for hosts this build knows. An unknown
      // host is a link written by a newer version — refused rather than
      // guessed at, so it cannot be silently opened as the wrong thing.
      test('rejects an unknown rinne host', () {
        expect(
          graph.LinkPropertyType.kindOf('rinne://obsidian-vault/notes.md'),
          isNull,
        );
      });

      test('rejects a bare path with no scheme', () {
        expect(graph.LinkPropertyType.kindOf('/Users/me/note.md'), isNull);
        expect(graph.LinkPropertyType.kindOf('notes/design.md'), isNull);
      });

      test('rejects empty and whitespace-only input', () {
        expect(graph.LinkPropertyType.kindOf(''), isNull);
        expect(graph.LinkPropertyType.kindOf('   '), isNull);
      });
    });

    group('normalize', () {
      // A file picker hands back a bare absolute path, and pasting one is the
      // natural thing to do, so it must land in the same shape as everything
      // else rather than being refused.
      test('turns a bare absolute path into a file URI', () {
        expect(
          graph.LinkPropertyType.normalize('/Users/me/note.md'),
          'file:///Users/me/note.md',
        );
      });

      test('escapes spaces in an absolute path', () {
        expect(
          graph.LinkPropertyType.normalize('/Users/me/my notes.md'),
          'file:///Users/me/my%20notes.md',
        );
      });

      test('leaves a URL unchanged', () {
        expect(
          graph.LinkPropertyType.normalize('https://notion.so/a-page'),
          'https://notion.so/a-page',
        );
      });

      test('leaves a stack-relative link unchanged', () {
        expect(
          graph.LinkPropertyType.normalize('rinne://stack/notes/design.md'),
          'rinne://stack/notes/design.md',
        );
      });

      test('trims surrounding whitespace', () {
        expect(
          graph.LinkPropertyType.normalize('  https://example.com  '),
          'https://example.com',
        );
      });

      test('returns null for input with no scheme', () {
        expect(graph.LinkPropertyType.normalize('notes/design.md'), isNull);
        expect(graph.LinkPropertyType.normalize(''), isNull);
      });

      test('is idempotent', () {
        final once = graph.LinkPropertyType.normalize('/Users/me/note.md')!;
        expect(graph.LinkPropertyType.normalize(once), once);
      });
    });

    group('displayLabel', () {
      test('shows the filename of a file link', () {
        expect(
          graph.LinkPropertyType.displayLabel('file:///Users/me/note.md'),
          'note.md',
        );
      });

      test('shows the filename of a stack-relative link', () {
        expect(
          graph.LinkPropertyType.displayLabel('rinne://stack/notes/design.md'),
          'design.md',
        );
      });

      test('decodes an escaped filename', () {
        expect(
          graph.LinkPropertyType.displayLabel('file:///Users/me/my%20notes.md'),
          'my notes.md',
        );
      });

      test('shows the last path segment of a URL', () {
        expect(
          graph.LinkPropertyType.displayLabel('https://notion.so/a-page'),
          'a-page',
        );
      });

      test('falls back to the host when there is no path', () {
        expect(
          graph.LinkPropertyType.displayLabel('https://example.com'),
          'example.com',
        );
      });

      test('falls back to the whole value when nothing else is meaningful', () {
        expect(graph.LinkPropertyType.displayLabel('mailto:'), 'mailto:');
      });
    });

    group('stackRelativePath', () {
      test('returns the path inside the stack', () {
        expect(
          graph.LinkPropertyType.stackRelativePath(
            'rinne://stack/notes/design.md',
          ),
          'notes/design.md',
        );
      });

      // Guards the resolver: an external link must never be joined onto the
      // stack directory, which would silently point at the wrong file.
      test('returns null for links that are not stack-relative', () {
        expect(
          graph.LinkPropertyType.stackRelativePath('file:///Users/me/note.md'),
          isNull,
        );
        expect(
          graph.LinkPropertyType.stackRelativePath('https://example.com/x'),
          isNull,
        );
        expect(
          graph.LinkPropertyType.stackRelativePath('rinne://other/notes.md'),
          isNull,
        );
      });
    });

    group('editableForm', () {
      // The schemes exist so three kinds of target fit in one field. Neither is
      // something a person writes, so neither belongs in front of them.
      test('drops the file scheme', () {
        expect(
          graph.LinkPropertyType.editableForm('file:///Users/me/note.md'),
          '/Users/me/note.md',
        );
      });

      test('drops the rinne scheme and host', () {
        expect(
          graph.LinkPropertyType.editableForm('rinne://stack/notes/design.md'),
          'notes/design.md',
        );
      });

      // A URL keeps its scheme: https:// is how anyone reads a web address,
      // and stripping it would leave something that no longer looks like one.
      test('keeps a URL whole', () {
        expect(
          graph.LinkPropertyType.editableForm('https://notion.so/a-page'),
          'https://notion.so/a-page',
        );
        expect(
          graph.LinkPropertyType.editableForm('obsidian://open?vault=Main'),
          'obsidian://open?vault=Main',
        );
      });

      test('decodes an escaped path', () {
        expect(
          graph.LinkPropertyType.editableForm('file:///Users/me/my%20notes.md'),
          '/Users/me/my notes.md',
        );
      });

      test('is empty for an empty value', () {
        expect(graph.LinkPropertyType.editableForm(''), '');
        expect(graph.LinkPropertyType.editableForm('   '), '');
      });

      test('leaves unparseable input alone', () {
        expect(
          graph.LinkPropertyType.editableForm('notes/design.md'),
          'notes/design.md',
        );
      });
    });

    group('normalizeForKind', () {
      // editableForm and normalizeForKind are inverses; the editor shows one
      // and stores the other, so a value that does not survive the pair would
      // be silently rewritten every time the field is focused.
      for (final entry
          in {
            'file:///Users/me/note.md': graph.LinkKind.externalFile,
            'file:///Users/me/my%20notes.md': graph.LinkKind.externalFile,
            'rinne://stack/notes/design.md': graph.LinkKind.stackRelative,
            'rinne://stack/my%20notes/a%20b.md': graph.LinkKind.stackRelative,
            'https://notion.so/a-page': graph.LinkKind.url,
          }.entries) {
        test('round-trips ${entry.key}', () {
          final shown = graph.LinkPropertyType.editableForm(entry.key);
          expect(
            graph.LinkPropertyType.normalizeForKind(shown, entry.value),
            entry.key,
          );
        });
      }

      // The same bare path means different things depending on the kind it was
      // entered under, which is why the kind has to be passed in.
      test('reads a bare path according to the kind', () {
        expect(
          graph.LinkPropertyType.normalizeForKind(
            '/Users/me/note.md',
            graph.LinkKind.externalFile,
          ),
          'file:///Users/me/note.md',
        );
        expect(
          graph.LinkPropertyType.normalizeForKind(
            'notes/design.md',
            graph.LinkKind.stackRelative,
          ),
          'rinne://stack/notes/design.md',
        );
      });

      test('is empty for empty input', () {
        for (final kind in graph.LinkKind.values) {
          expect(graph.LinkPropertyType.normalizeForKind('', kind), '');
          expect(graph.LinkPropertyType.normalizeForKind('  ', kind), '');
        }
      });
    });

    group('relativeToStack', () {
      const stack = '/Users/me/Documents/App/Stacks/Work.stack';

      test('strips the stack directory from a file inside it', () {
        expect(
          graph.LinkPropertyType.relativeToStack(
            '$stack/notes/design.md',
            stack,
          ),
          'notes/design.md',
        );
      });

      test('tolerates a trailing slash on the stack path', () {
        expect(
          graph.LinkPropertyType.relativeToStack(
            '$stack/notes/design.md',
            '$stack/',
          ),
          'notes/design.md',
        );
      });

      // The promise of a stack-relative link is that the file travels with the
      // stack. A file outside it cannot keep that promise.
      test('refuses a file outside the stack', () {
        expect(
          graph.LinkPropertyType.relativeToStack('/Users/me/note.md', stack),
          isNull,
        );
      });

      // A sibling directory sharing a name prefix must not look like a child:
      // "…/Work.stack.backup/x" starts with "…/Work.stack" as a string.
      test('refuses a sibling whose name merely starts the same', () {
        expect(
          graph.LinkPropertyType.relativeToStack(
            '$stack.backup/notes/design.md',
            stack,
          ),
          isNull,
        );
      });

      test('refuses the stack directory itself', () {
        expect(graph.LinkPropertyType.relativeToStack(stack, stack), isNull);
        expect(
          graph.LinkPropertyType.relativeToStack('$stack/', stack),
          isNull,
        );
      });

      test('returns null when there is no stack', () {
        expect(
          graph.LinkPropertyType.relativeToStack('/Users/me/note.md', null),
          isNull,
        );
        expect(
          graph.LinkPropertyType.relativeToStack('/Users/me/note.md', ''),
          isNull,
        );
      });
    });

    group('stackRelativeUri', () {
      test('builds a link from a relative path', () {
        expect(
          graph.LinkPropertyType.stackRelativeUri('notes/design.md'),
          'rinne://stack/notes/design.md',
        );
      });

      test('tolerates a leading slash', () {
        expect(
          graph.LinkPropertyType.stackRelativeUri('/notes/design.md'),
          'rinne://stack/notes/design.md',
        );
      });

      // Round-tripping is what makes a picked file usable: the name shown in
      // the field has to survive being stored and read back.
      test('round-trips a name with a space', () {
        final uri = graph.LinkPropertyType.stackRelativeUri('my notes/a b.md');
        expect(
          graph.LinkPropertyType.stackRelativePath(uri),
          'my notes/a b.md',
        );
      });

      test('round-trips a name with a hash', () {
        final uri = graph.LinkPropertyType.stackRelativeUri('notes/draft#2.md');
        expect(
          graph.LinkPropertyType.stackRelativePath(uri),
          'notes/draft#2.md',
        );
      });

      test('round-trips a non-ASCII name', () {
        final uri = graph.LinkPropertyType.stackRelativeUri('メモ/設計.md');
        expect(graph.LinkPropertyType.stackRelativePath(uri), 'メモ/設計.md');
      });

      test('produces a link that classifies as stack-relative', () {
        final uri = graph.LinkPropertyType.stackRelativeUri('notes/design.md');
        expect(
          graph.LinkPropertyType.kindOf(uri),
          graph.LinkKind.stackRelative,
        );
        expect(const graph.LinkPropertyType().isValid(uri), isTrue);
      });
    });

    group('validation', () {
      test('accepts each of the three kinds', () {
        expect(type.isValid('rinne://stack/notes/design.md'), isTrue);
        expect(type.isValid('file:///Users/me/note.md'), isTrue);
        expect(type.isValid('https://notion.so/a-page'), isTrue);
      });

      // A property can be added before its value is known; refusing to save an
      // empty one would trap the user in the editor.
      test('accepts an empty value', () {
        expect(type.isValid(''), isTrue);
        expect(type.validate('').isValid, isTrue);
        expect(type.validate('   ').isValid, isTrue);
      });

      test('rejects a bare path', () {
        expect(type.isValid('/Users/me/note.md'), isFalse);
        expect(type.validate('/Users/me/note.md').isValid, isFalse);
      });

      test('rejects non-string values', () {
        expect(type.isValid(42), isFalse);
        expect(type.validate(42).isValid, isFalse);
      });

      // Matches the sibling types: PropertyType.validate's doc comment claims
      // null is always valid, but no implementation behaves that way.
      test('rejects null, matching the other property types', () {
        expect(type.validate(null).isValid, isFalse);
      });
    });

    test('converts a bare path to a file URI', () {
      expect(
        type.convertValue('/Users/me/note.md'),
        'file:///Users/me/note.md',
      );
      expect(type.convertValue(null), isNull);
    });

    // Unconvertible input is kept rather than dropped: losing what the user
    // typed is worse than storing something the editor will flag.
    test('keeps unconvertible input as-is', () {
      expect(type.convertValue('notes/design.md'), 'notes/design.md');
    });

    test('is named link and is distinct from text', () {
      expect(type.name, 'link');
      expect(type, isNot(isA<graph.TextPropertyType>()));
    });
  });

  // Invariants that make a future property type self-checking: a descriptor
  // whose build disagrees with its own type name would otherwise only surface
  // as a type that silently fails to round-trip through a definition.
  group('PropertyTypeRegistry', () {
    test('every descriptor builds the type it names', () {
      for (final descriptor in graph.PropertyTypeRegistry.all) {
        expect(
          descriptor.build(const {}).name,
          descriptor.typeName,
          reason:
              'descriptor "${descriptor.typeName}" builds a mismatched type',
        );
      }
    });

    // Type names may repeat — the link entries share one — but the picker ids
    // that tell those entries apart must not, or a selection would be
    // ambiguous.
    test('picker ids are unique', () {
      final ids =
          graph.PropertyTypeRegistry.all
              .map((descriptor) => descriptor.pickerId)
              .toList();
      expect(ids.toSet().length, ids.length);
    });

    test('a picker id round-trips to its own descriptor', () {
      for (final descriptor in graph.PropertyTypeRegistry.all) {
        final found = graph.PropertyTypeRegistry.lookupByPickerId(
          descriptor.pickerId,
        );
        expect(found?.pickerId, descriptor.pickerId);
        expect(found?.typeName, descriptor.typeName);
      }
    });

    // The three link entries are one stored type, so a caller asking which
    // types may be assigned must see it once.
    test('selectable type names are deduplicated', () {
      final names = graph.PropertyTypeRegistry.selectableTypeNames;
      expect(names.toSet().length, names.length);
      expect(names.where((name) => name == 'link').length, 1);
    });

    test('every link kind is offered as its own picker entry', () {
      final offered =
          graph.PropertyTypeRegistry.selectable
              .where((descriptor) => descriptor.typeName == 'link')
              .map((descriptor) => descriptor.initialLinkKind)
              .toSet();
      expect(offered, graph.LinkKind.values.toSet());
    });

    test('non-link entries carry no link kind', () {
      for (final descriptor in graph.PropertyTypeRegistry.all) {
        if (descriptor.typeName == 'link') continue;
        expect(descriptor.initialLinkKind, isNull);
      }
    });

    test('every descriptor has a non-empty label', () {
      for (final descriptor in graph.PropertyTypeRegistry.all) {
        expect(descriptor.label, isNotEmpty);
      }
    });

    test('selectable types are a subset of supported types, in menu order', () {
      final selectable = graph.PropertyTypeRegistry.selectableTypeNames;
      expect(selectable, isNotEmpty);
      for (final name in selectable) {
        expect(graph.PropertyTypeRegistry.isSupported(name), isTrue);
      }
      // Text leads the picker because it is the default and the common case.
      expect(selectable.first, 'text');
    });

    test('lookup returns null for an unknown type name', () {
      expect(graph.PropertyTypeRegistry.lookup('no-such-type'), isNull);
      expect(graph.PropertyTypeRegistry.isSupported('no-such-type'), isFalse);
    });

    test('link and memo are both offered', () {
      expect(
        graph.PropertyTypeRegistry.selectableTypeNames,
        containsAll(<String>['memo', 'link']),
      );
    });
  });

  // The picker offering three link entries is only real if the choice survives
  // being written to a definition and read back. It did not at first: the kind
  // was stored as a UI hint, which toPropertyType() drops, so every link
  // property came back as a URL no matter which entry was picked.
  group('link kind round-trip', () {
    /// Builds the definition the editor would write for [pickerId].
    graph.GlobalPropertyTypeDefinition definitionFor(String pickerId) {
      final descriptor = graph.PropertyTypeRegistry.lookupByPickerId(pickerId)!;
      final now = DateTime.now();
      return graph.GlobalPropertyTypeDefinition(
        typeName: descriptor.typeName,
        constraints:
            descriptor.initialLinkKind == null
                ? const {}
                : {
                  graph.LinkPropertyType.defaultKindConstraint:
                      descriptor.initialLinkKind!.name,
                },
        createdAt: now,
        updatedAt: now,
      );
    }

    for (final kind in graph.LinkKind.values) {
      test(
        'a property added as ${kind.name} resolves back to ${kind.name}',
        () {
          final definition = definitionFor('link:${kind.name}');
          final type = definition.toPropertyType();

          expect(type, isA<graph.LinkPropertyType>());
          expect((type! as graph.LinkPropertyType).defaultKind, kind);
        },
      );
    }

    test('every link definition is valid', () {
      for (final kind in graph.LinkKind.values) {
        expect(definitionFor('link:${kind.name}').isValid(), isTrue);
      }
    });

    test('the definition survives a JSON round-trip', () {
      final restored = graph.GlobalPropertyTypeDefinition.fromJson(
        definitionFor('link:externalFile').toJson(),
      );
      final type = restored.toPropertyType()! as graph.LinkPropertyType;
      expect(type.defaultKind, graph.LinkKind.externalFile);
    });

    // A bare 'link' — what the command writes when no variant is given, and
    // what any definition written before the variants existed looks like.
    test('a link with no recorded kind has no preference', () {
      final now = DateTime.now();
      final definition = graph.GlobalPropertyTypeDefinition(
        typeName: 'link',
        createdAt: now,
        updatedAt: now,
      );
      expect(definition.isValid(), isTrue);
      final type = definition.toPropertyType()! as graph.LinkPropertyType;
      expect(type.defaultKind, isNull);
    });

    // Forward compatibility: a kind this build does not know should degrade to
    // "no preference" rather than invalidating the definition.
    test('an unknown kind name degrades to no preference', () {
      final now = DateTime.now();
      final definition = graph.GlobalPropertyTypeDefinition(
        typeName: 'link',
        constraints: const {
          graph.LinkPropertyType.defaultKindConstraint: 'someFutureKind',
        },
        createdAt: now,
        updatedAt: now,
      );
      expect(definition.isValid(), isTrue);
      final type = definition.toPropertyType()! as graph.LinkPropertyType;
      expect(type.defaultKind, isNull);
    });

    // The recorded kind is only a starting point. A value always wins, so a
    // property added as "External file" that holds a URL presents as a URL.
    test('a stored value outranks the recorded kind', () {
      final type =
          definitionFor('link:externalFile').toPropertyType()!
              as graph.LinkPropertyType;
      expect(type.defaultKind, graph.LinkKind.externalFile);
      expect(
        graph.LinkPropertyType.kindOf('https://example.com'),
        graph.LinkKind.url,
      );
    });
  });
}
