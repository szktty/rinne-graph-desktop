/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/entity_properties_providers.dart';

/// A widget that displays the properties of a selected entity in the graph view
///
/// Dynamically retrieves and displays properties as key-value pairs.
/// Property names are not hardcoded.
class GraphEntityPropertiesDisplay extends ConsumerWidget {
  /// Constructor
  const GraphEntityPropertiesDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    // Monitor properties being edited
    final editingProperties = ref.watch(editingEntityPropertiesProvider);
    final editingPropertyKeys = editingProperties.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header with Save/Cancel buttons
        _buildHeader(appColorScheme),
        // Scrollable content.
        //
        // Labels are deliberately not shown here: the Info tab already lists
        // them, and repeating them in two tabs of the same panel reads as two
        // separate fields.
        //
        // No padding is applied around the content either — the tab host
        // (FondeTabView.contentPadding) already insets it.
        Expanded(
          child: FondeScrollView(
            child: _buildPropertiesSection(
              properties: editingProperties,
              propertyKeys: editingPropertyKeys,
              colorScheme: appColorScheme,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the editor header with Save/Cancel icon buttons
  Widget _buildHeader(AppColorScheme colorScheme) {
    return Consumer(
      builder: (context, ref, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.base.divider, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(FondeIcons.save),
                iconSize: 18.0,
                tooltip: 'Save',
                onPressed: () => _saveProperties(context, ref),
                color: colorScheme.base.foreground,
              ),
              const SizedBox(width: 4.0),
              IconButton(
                icon: Icon(FondeIcons.rotateCcw),
                iconSize: 18.0,
                tooltip: 'Cancel',
                onPressed: () => _cancelEditing(ref),
                color: colorScheme.base.foreground,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the properties section
  Widget _buildPropertiesSection({
    required Map<String, dynamic> properties,
    required List<String> propertyKeys,
    required AppColorScheme colorScheme,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        // Monitor properties being edited and update UI when property name changes
        final currentEditingProperties = ref.watch(
          editingEntityPropertiesProvider,
        );
        final currentPropertyKeys = currentEditingProperties.keys.toList();

        // Resolved against the entity's own labels. Still loading, or no stack
        // open, leaves every property untyped — which renders exactly as it did
        // before types existed, so the panel never blocks on this.
        final labels = ref.watch(selectedEntityLabelsProvider);
        final resolvedTypes =
            ref.watch(propertyTypesForLabelsProvider(labels)).value ??
            const <String, PropertyType>{};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Properties', variant: AppTextVariant.sectionTitlePrimary),
            const SizedBox(height: 12),
            if (currentPropertyKeys.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AppText(
                  'No properties',
                  variant: AppTextVariant.bodyText,
                  color: colorScheme.base.foreground.withAlpha(128),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    currentPropertyKeys.map((key) {
                      final value = currentEditingProperties[key];
                      final type = resolvedTypes[key];
                      return _buildEditablePropertyItem(
                        key: key,
                        value: value,
                        colorScheme: colorScheme,
                        type: type,
                        onChanged: (newValue) {
                          ref
                              .read(editingEntityPropertiesProvider.notifier)
                              .updateProperty(
                                key,
                                // A declared textual type wins over whatever
                                // the current value happens to look like —
                                // otherwise a memo whose text reads "42" would
                                // be coerced to a number, and a link would be
                                // rewritten the same way.
                                _isTextualType(type)
                                    ? newValue
                                    : _coerceToOriginalType(value, newValue),
                              );
                        },
                        onRemove: () {
                          ref
                              .read(editingEntityPropertiesProvider.notifier)
                              .removeProperty(key);
                        },
                      );
                    }).toList(),
              ),
            const SizedBox(height: 8),
            _AddPropertyButton(
              existingKeys: currentPropertyKeys.toSet(),
              colorScheme: colorScheme,
            ),
          ],
        );
      },
    );
  }

  /// Whether [type] stores its value as text regardless of what it looks like.
  ///
  /// These types bypass [_coerceToOriginalType]: their value is a string by
  /// definition, so re-parsing it as a number or a boolean would corrupt it.
  static bool _isTextualType(PropertyType? type) =>
      type is MemoPropertyType || type is TextPropertyType;

  /// Keeps an edited value at the type it started as.
  ///
  /// The text field hands back a String for every property, so editing a
  /// numeric or boolean property would otherwise rewrite it as text and the
  /// type would be lost on save. If the new text no longer parses as the
  /// original type — the user cleared the field, or typed a word into a
  /// number — it is kept as a String rather than rejected, since the property
  /// values are untyped by design.
  static dynamic _coerceToOriginalType(dynamic original, String text) {
    if (original is int) {
      return int.tryParse(text) ?? text;
    }
    if (original is double) {
      return double.tryParse(text) ?? text;
    }
    if (original is bool) {
      final lower = text.toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
      return text;
    }
    return text;
  }

  /// Builds an editable property item
  Widget _buildEditablePropertyItem({
    required String key,
    required dynamic value,
    required AppColorScheme colorScheme,
    required PropertyType? type,
    required ValueChanged<String> onChanged,
    required VoidCallback onRemove,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final editingNames = ref.watch(editingPropertyNamesProvider);
        final isEditingName = editingNames.containsKey(key);
        final editingName = editingNames[key] ?? key;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Property name (editable)
                  Expanded(
                    child: _buildEditablePropertyName(
                      key: key,
                      isEditing: isEditingName,
                      editingName: editingName,
                      colorScheme: colorScheme,
                      ref: ref,
                    ),
                  ),
                  // Removal takes effect on Save, like every other edit here,
                  // so it needs no confirmation of its own — Cancel restores
                  // the property.
                  IconButton(
                    icon: Icon(FondeIcons.deleteOutline),
                    iconSize: 14.0,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Remove property',
                    onPressed: onRemove,
                    color: colorScheme.base.foreground.withAlpha(150),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Property value
              _PropertyValueField(
                // Keyed by property name so that renaming or reordering
                // rebinds the field to the right value instead of carrying the
                // previous property's text across.
                key: ValueKey('property_value_$key'),
                initialText: _formatValue(value),
                type: type,
                colorScheme: colorScheme,
                onChanged: onChanged,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// Builds an editable property name
  Widget _buildEditablePropertyName({
    required String key,
    required bool isEditing,
    required String editingName,
    required AppColorScheme colorScheme,
    required WidgetRef ref,
  }) {
    if (isEditing) {
      return _buildPropertyNameEditor(
        key: key,
        editingName: editingName,
        colorScheme: colorScheme,
        ref: ref,
      );
    } else {
      return GestureDetector(
        onTap: () {
          ref
              .read(editingPropertyNamesProvider.notifier)
              .startEditing(key, key);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AppText(
            key,
            variant: AppTextVariant.captionText,
            color: colorScheme.base.foreground.withAlpha(180),
          ),
        ),
      );
    }
  }

  /// Builds the property name editor
  Widget _buildPropertyNameEditor({
    required String key,
    required String editingName,
    required AppColorScheme colorScheme,
    required WidgetRef ref,
  }) {
    return _PropertyNameEditorWidget(
      key: ValueKey('property_name_editor_$key'),
      propertyKey: key,
      editingName: editingName,
      colorScheme: colorScheme,
      onFinish: (newName) {
        _finishEditingPropertyName(key, newName, ref);
      },
    );
  }

  /// Finishes editing the property name
  void _finishEditingPropertyName(
    String oldKey,
    String newName,
    WidgetRef ref,
  ) {
    print('[PropertyNameEdit] ===== Property name editing finished =====');
    print('[PropertyNameEdit] Old key: $oldKey');
    print('[PropertyNameEdit] New name: $newName');

    final trimmedName = newName.trim();

    if (trimmedName.isEmpty || trimmedName == oldKey) {
      // If there are no changes, finish editing
      print('[PropertyNameEdit] No changes, finishing editing');
      ref.read(editingPropertyNamesProvider.notifier).stopEditing(oldKey);
      return;
    }

    // Update property value being edited (change key)
    final editingProperties = ref.read(editingEntityPropertiesProvider);

    // Renaming onto a name already in use would overwrite that property's
    // value on save, losing it silently. The edit is abandoned instead, which
    // leaves the original name in place.
    if (editingProperties.containsKey(trimmedName)) {
      print('[PropertyNameEdit] Name "$trimmedName" already used, cancelling');
      ref.read(editingPropertyNamesProvider.notifier).stopEditing(oldKey);
      return;
    }

    // Record property name change
    print(
      '[PropertyNameEdit] Recording property name change: $oldKey -> $trimmedName',
    );
    ref
        .read(editingPropertyNameChangesProvider.notifier)
        .renameProperty(oldKey, trimmedName);

    print(
      '[PropertyNameEdit] Current properties being edited: $editingProperties',
    );
    print('[PropertyNameEdit] Value of old key: ${editingProperties[oldKey]}');

    // Keyed by presence, not by a null check: a property added but not yet
    // filled in holds an empty string, and one whose value is genuinely null
    // still has to survive being renamed.
    if (editingProperties.containsKey(oldKey)) {
      // Rebuilt in one pass, preserving position. Writing the new key and then
      // calling setProperties with a copy of the map read *before* that write
      // dropped the property altogether: the copy never had the new key, and
      // it replaced the state that did.
      final renamed = <String, dynamic>{};
      for (final entry in editingProperties.entries) {
        if (entry.key == oldKey) {
          renamed[trimmedName] = entry.value;
        } else {
          renamed[entry.key] = entry.value;
        }
      }

      print('[PropertyNameEdit] Renamed $oldKey -> $trimmedName');
      print('[PropertyNameEdit] Updated properties: $renamed');
      ref.read(editingEntityPropertiesProvider.notifier).setProperties(renamed);

      // Carry the type across, or a renamed memo comes back as plain text.
      final manager = ref.read(propertyTypeManagerProvider);
      final labels = ref.read(selectedEntityLabelsProvider);
      if (manager != null && labels.isNotEmpty) {
        unawaited(
          manager
              .renameLabelPropertyType(labels.first, oldKey, trimmedName)
              .then((_) {
                ref.invalidate(propertyTypesForLabelsProvider);
              }),
        );
      }
    } else {
      print('[PropertyNameEdit] Warning: Value for old key not found');
    }

    // Finish editing
    print('[PropertyNameEdit] Finishing editing');
    ref.read(editingPropertyNamesProvider.notifier).stopEditing(oldKey);
    print('[PropertyNameEdit] ===== Editing finished =====');
  }

  /// Saves properties
  Future<void> _saveProperties(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(saveEntityActionProvider.notifier).saveEntity();
      // After successful save, reset editing state (already reset by SaveEntityAction)
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Properties saved')));
      }
    } on PropertyValidationException catch (e) {
      // A dialog rather than the snackbar below: this is the user's own input
      // to fix, and nothing was saved. A snackbar would let them walk away
      // believing the value was stored.
      if (context.mounted) {
        await showAppErrorDialog(
          context,
          message: e.message,
          details: e.details,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    }
  }

  /// Cancels editing
  void _cancelEditing(WidgetRef ref) {
    ref.read(editingEntityPropertiesProvider.notifier).reset();
    ref.read(editingPropertyNameChangesProvider.notifier).reset();
    ref.read(editingPropertyNamesProvider.notifier).reset();
  }

  /// Formats the value
  String _formatValue(dynamic value) {
    if (value == null) {
      return 'null';
    }
    if (value is List) {
      return '[${value.join(', ')}]';
    }
    if (value is Map) {
      return '{...}';
    }
    return value.toString();
  }
}

/// The value field of one property.
///
/// Stateful so that it owns its [TextEditingController] for as long as the
/// property is on screen. Building the controller inside the enclosing
/// `Consumer` recreated it on every rebuild, which reset the selection — barely
/// visible in a one-line field, but a memo is several lines and the caret and
/// scroll position jumped away mid-edit.
class _PropertyValueField extends StatefulWidget {
  const _PropertyValueField({
    super.key,
    required this.initialText,
    required this.type,
    required this.colorScheme,
    required this.onChanged,
  });

  final String initialText;

  /// The property's declared type, or null when it has none.
  ///
  /// Passed whole rather than as a set of booleans so that adding a type with
  /// its own editor does not add another flag to thread through this widget.
  final PropertyType? type;

  final AppColorScheme colorScheme;
  final ValueChanged<String> onChanged;

  @override
  State<_PropertyValueField> createState() => _PropertyValueFieldState();
}

class _PropertyValueFieldState extends State<_PropertyValueField> {
  late final TextEditingController _controller;

  /// Grapheme count of the current text, recomputed only on change.
  late int _length;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _length = MemoPropertyType.lengthOf(widget.initialText);
  }

  @override
  void didUpdateWidget(_PropertyValueField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only adopt external text when it genuinely differs from what is in the
    // field — assigning unconditionally would fight the user's own typing,
    // since every keystroke comes back through this widget.
    if (widget.initialText != oldWidget.initialText &&
        widget.initialText != _controller.text) {
      _controller.text = widget.initialText;
      _length = MemoPropertyType.lengthOf(widget.initialText);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String text) {
    if (widget.type is MemoPropertyType) {
      final length = MemoPropertyType.lengthOf(text);
      if (length != _length) {
        setState(() => _length = length);
      }
    }
    widget.onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    final linkType = widget.type;
    if (linkType is LinkPropertyType) {
      return _LinkValueField(
        controller: _controller,
        type: linkType,
        colorScheme: widget.colorScheme,
        onChanged: _handleChanged,
      );
    }

    if (widget.type is! MemoPropertyType) {
      return FondeTextField(
        controller: _controller,
        onChanged: _handleChanged,
        hintText: 'Enter value',
      );
    }

    const limit = MemoPropertyType.maxLength;
    final isOver = _length > limit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FondeTextField(
          controller: _controller,
          onChanged: _handleChanged,
          hintText: 'Enter memo',
          maxLines: 5,
          // Deliberately no maxLength: it counts UTF-16 units, so it would cut
          // an emoji-heavy memo short of 500 graphemes and split the pair.
          // Going over is shown here and refused on save instead of being
          // blocked mid-keystroke.
          errorText: isOver ? '$_length / $limit characters' : null,
        ),
        // A gradient rather than a wall: silent while there is room, a quiet
        // remaining-count once the memo is long enough that splitting the node
        // is worth considering, and an error only past the limit.
        if (!isOver && _length >= MemoPropertyType.counterThreshold)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: AppText(
              '${limit - _length} characters left',
              variant: AppTextVariant.captionText,
              color: widget.colorScheme.base.foreground.withAlpha(128),
            ),
          ),
      ],
    );
  }
}

/// The value field of a link property.
///
/// Three kinds of link ([LinkKind]) share one stored form — a URI string — but
/// they are not entered the same way, so the input follows from the kind. The
/// kind is chosen in the type picker and is not asked for again here.
class _LinkValueField extends ConsumerStatefulWidget {
  const _LinkValueField({
    required this.controller,
    required this.type,
    required this.colorScheme,
    required this.onChanged,
  });

  final TextEditingController controller;

  /// The property's declared link type, carrying the kind it was created as.
  final LinkPropertyType type;

  final AppColorScheme colorScheme;
  final ValueChanged<String> onChanged;

  @override
  ConsumerState<_LinkValueField> createState() => _LinkValueFieldState();
}

class _LinkValueFieldState extends ConsumerState<_LinkValueField> {
  /// Which kind of link this field is editing.
  ///
  /// The value wins when there is one — a link that holds something is what it
  /// holds, and can never present as the wrong kind. An empty property has
  /// nothing to read, so it falls back to the kind chosen in the type picker,
  /// and to a URL only when no choice was recorded.
  late final LinkKind _kind;

  /// The field's own controller, holding display text rather than the value.
  ///
  /// Separate from the parent's controller, which keeps the stored URI: what
  /// the field shows and what gets saved are deliberately different here.
  late final TextEditingController _controller;

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _kind =
        LinkPropertyType.kindOf(widget.controller.text) ??
        widget.type.defaultKind ??
        LinkKind.url;

    _controller = TextEditingController(text: _collapsedText());
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  /// The stored value this field is editing, taken from the parent.
  String get _storedValue => widget.controller.text;

  /// What the field shows when it is not being edited.
  ///
  /// An absolute path does not fit in a property row and is mostly directories
  /// the user already knows, so a file collapses to its name. A URL is left
  /// whole — the host is the informative part and truncating it would hide
  /// which site the link points at.
  String _collapsedText() {
    final value = _storedValue;
    if (value.trim().isEmpty) return '';
    if (_kind == LinkKind.url) return LinkPropertyType.editableForm(value);
    return LinkPropertyType.displayLabel(value);
  }

  /// What the field shows while it is being edited.
  ///
  /// The whole path, minus the scheme: editing has to be able to reach every
  /// part of the value, and a filename alone cannot be edited into a different
  /// directory.
  String _expandedText() => LinkPropertyType.editableForm(_storedValue);

  /// Swaps the text between the collapsed and expanded forms.
  ///
  /// Focus is the signal because it is exactly when the two forms are wanted:
  /// reading wants the short one, typing needs the full one.
  void _handleFocusChange() {
    final text = _focusNode.hasFocus ? _expandedText() : _collapsedText();
    if (_controller.text == text) return;

    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  static IconData _iconFor(LinkKind kind) => switch (kind) {
    LinkKind.stackRelative => FondeIcons.folder,
    LinkKind.externalFile => FondeIcons.fileText,
    LinkKind.url => FondeIcons.globe,
  };

  static String _hintFor(LinkKind kind) => switch (kind) {
    LinkKind.stackRelative => 'notes/design.md',
    LinkKind.externalFile => 'Choose a file, or enter a path',
    LinkKind.url => 'https://example.com/page',
  };

  /// Records [text] as the stored value.
  ///
  /// The parent's controller is written directly because this field no longer
  /// binds it to a text box — it is the value, while [_controller] holds
  /// whatever form of it is currently on screen.
  void _store(String text) {
    final stored = LinkPropertyType.normalizeForKind(text, _kind);
    widget.controller.text = stored;
    widget.onChanged(stored);
  }

  void _handleTextChanged(String text) => _store(text);

  /// The stack directory a stack-relative link is resolved against.
  String? get _stackPath => ref.read(propertyTypeStackPathProvider);

  Future<void> _pickFile() async {
    // Both kinds start inside the stack when there is one: for a stack-relative
    // link the file has to be in there, and for an external one it is a
    // harmless starting point.
    final stackPath = _stackPath;

    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        dialogTitle:
            _kind == LinkKind.stackRelative
                ? 'Choose a file inside this stack'
                : 'Choose a file',
        initialDirectory: stackPath,
      );
    } on PlatformException catch (e) {
      // Reported rather than swallowed: a picker that fails silently looks
      // like a dead button, which is exactly how this read before.
      print('[LinkValueField] File picker failed: ${e.message}');
      await _reportBrokenLink(
        'Could not open the file chooser.',
        e.message ?? 'The system file dialog is unavailable.',
      );
      return;
    }

    final files = result?.files ?? const [];
    final path = files.isEmpty ? null : files.first.path;
    if (path == null) return;

    if (_kind != LinkKind.stackRelative) {
      _adoptPickedFile(path);
      return;
    }

    // A file outside the stack cannot be addressed relative to it. Refusing
    // beats silently storing an absolute path under a kind that promises the
    // link travels with the stack.
    final relative = LinkPropertyType.relativeToStack(path, stackPath);
    if (relative == null) {
      await _reportBrokenLink(
        'That file is outside this stack.',
        'Choose a file inside the stack directory, or use an external file '
            'link instead.',
      );
      return;
    }

    _adoptPickedFile(relative);
  }

  /// Stores a freshly picked path and shows it in its collapsed form.
  ///
  /// The parent has to be told first: the display text is derived from the
  /// stored value, so collapsing before storing would read the old link.
  void _adoptPickedFile(String enteredPath) {
    _store(enteredPath);
    setState(() {
      final text = _collapsedText();
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    });
  }

  /// Reveals the link's target in the system file browser.
  ///
  /// Only offered for the two file kinds — there is nothing to reveal for a
  /// URL. This is the counterpart to opening: one runs the file, the other
  /// shows where it lives.
  Future<void> _revealInFinder() async {
    final file = _resolveForOpening(_storedValue);
    if (file == null || file.scheme != 'file') {
      await _reportBrokenLink(
        'This link cannot be shown.',
        'It does not point at a file on this machine.',
      );
      return;
    }

    final path = file.toFilePath();
    if (!File(path).existsSync() && !Directory(path).existsSync()) {
      await _reportBrokenLink(
        'That file no longer exists.',
        'It may have been moved or deleted. Choose the file again to relink '
            'it.',
      );
      return;
    }

    try {
      final result = await Process.run('open', ['-R', path]);
      if (result.exitCode != 0) {
        await _reportBrokenLink(
          'Could not show this file.',
          'The file browser reported: ${result.stderr}',
        );
      }
    } on ProcessException catch (e) {
      print('[LinkValueField] Failed to reveal $path: ${e.message}');
      await _reportBrokenLink('Could not show this file.', e.message);
    }
  }

  /// Opens the link with whatever the OS considers its default application.
  ///
  /// Existence is checked here rather than while rendering: a property row
  /// would otherwise touch the filesystem on every rebuild, and a link on a
  /// network volume would stall the editor.
  Future<void> _openLink() async {
    final value = _storedValue;
    if (value.isEmpty) return;

    final target = _resolveForOpening(value);
    if (target == null) {
      await _reportBrokenLink(
        'This link cannot be opened.',
        'It is not a valid URL or file path. Check the value and try again.',
      );
      return;
    }

    var launched = false;
    try {
      launched = await launchUrl(target);
    } on PlatformException catch (e) {
      print('[LinkValueField] Failed to open $target: ${e.message}');
      launched = false;
    }

    if (!launched) {
      await _reportBrokenLink(
        'Could not open this link.',
        'The file may have been moved or deleted, or no application is '
            'associated with it.',
      );
    }
  }

  /// Turns a stored value into something the OS can open.
  ///
  /// A stack-relative link only means anything once it is joined to the stack
  /// it belongs to, which is why this needs the active stack's path.
  Uri? _resolveForOpening(String value) {
    final relative = LinkPropertyType.stackRelativePath(value);
    if (relative == null) return Uri.tryParse(value);

    final stackPath = ref.read(propertyTypeStackPathProvider);
    if (stackPath == null) return null;
    return Uri.file('$stackPath/$relative');
  }

  Future<void> _reportBrokenLink(String message, String details) async {
    if (!mounted) return;
    await showAppErrorDialog(context, message: message, details: details);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _storedValue.trim().isNotEmpty;
    final isFile = _kind != LinkKind.url;

    // No kind selector here on purpose. The kind was already chosen in the
    // type picker, and the value itself says which kind it is once there is
    // one — offering the same three choices a second time would put internal
    // structure back in front of the user.
    return Row(
      children: [
        Icon(
          _iconFor(_kind),
          size: 14.0,
          color: widget.colorScheme.base.foreground.withAlpha(150),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: FondeTextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _handleTextChanged,
            hintText: _hintFor(_kind),
          ),
        ),
        // Both file kinds get a chooser. A stack-relative link needs one just
        // as much as an external one — more so, since its stored form is a
        // path relative to a directory the user should not have to know.
        if (isFile)
          IconButton(
            icon: Icon(FondeIcons.folderOpen),
            iconSize: 16.0,
            visualDensity: VisualDensity.compact,
            tooltip: 'Choose a file',
            onPressed: _pickFile,
            color: widget.colorScheme.base.foreground.withAlpha(180),
          ),
        IconButton(
          icon: Icon(FondeIcons.link),
          iconSize: 16.0,
          visualDensity: VisualDensity.compact,
          // A file is run by whatever application owns it; a URL goes to the
          // browser. Naming the action for what it does to a file avoids
          // "Open link" reading as "show me where it is".
          tooltip: isFile ? 'Open with default app' : 'Open link',
          onPressed: hasValue ? _openLink : null,
          color: widget.colorScheme.base.foreground.withAlpha(180),
        ),
        // Revealing is only meaningful for something that has a location on
        // this machine, so a URL does not get this.
        if (isFile)
          IconButton(
            icon: Icon(FondeIcons.folder),
            iconSize: 16.0,
            visualDensity: VisualDensity.compact,
            tooltip: 'Show in Finder',
            onPressed: hasValue ? _revealInFinder : null,
            color: widget.colorScheme.base.foreground.withAlpha(180),
          ),
      ],
    );
  }
}

/// "Add property" control: a button that turns into a name field when tapped.
///
/// The new property is added with an empty value and takes effect on Save,
/// like every other edit in this panel.
class _AddPropertyButton extends ConsumerStatefulWidget {
  const _AddPropertyButton({
    required this.existingKeys,
    required this.colorScheme,
  });

  final Set<String> existingKeys;
  final AppColorScheme colorScheme;

  @override
  ConsumerState<_AddPropertyButton> createState() => _AddPropertyButtonState();
}

class _AddPropertyButtonState extends ConsumerState<_AddPropertyButton> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isAdding = false;
  String? _error;

  /// The picker entry currently chosen, not a bare type name.
  ///
  /// The link types share one type name across three entries, so the selection
  /// has to be identified by [PropertyTypeDescriptor.pickerId].
  String _pickerId = 'text';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isAdding = true;
      _error = null;
      _pickerId = 'text';
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _cancel() {
    setState(() {
      _isAdding = false;
      _error = null;
    });
  }

  void _commit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      _cancel();
      return;
    }
    if (widget.existingKeys.contains(name)) {
      setState(() => _error = 'Property "$name" already exists');
      return;
    }
    ref.read(editingEntityPropertiesProvider.notifier).addProperty(name);
    unawaited(_persistTypeDefinition(name));
    setState(() {
      _isAdding = false;
      _error = null;
    });
  }

  /// Records the chosen type against the entity's label.
  ///
  /// Text is deliberately not written: it is what an undefined property
  /// already resolves to, so storing it would grow property_types.json for
  /// every property added without changing any behaviour.
  ///
  /// Scoped to the first label, matching how the type is resolved on the way
  /// back out. An entity with no labels has nothing to scope to, so the type
  /// is dropped and the property stays untyped.
  Future<void> _persistTypeDefinition(String propertyName) async {
    final descriptor = PropertyTypeRegistry.lookupByPickerId(_pickerId);
    if (descriptor == null || descriptor.typeName == 'text') return;

    final manager = ref.read(propertyTypeManagerProvider);
    if (manager == null) return;

    final labels = ref.read(selectedEntityLabelsProvider);
    if (labels.isEmpty) return;

    final now = DateTime.now();
    await manager.setLabelPropertyType(
      labels.first,
      propertyName,
      GlobalPropertyTypeDefinition(
        typeName: descriptor.typeName,
        // Recorded as a constraint rather than a UI hint so that it survives
        // the trip back out: the resolved-type providers rebuild a
        // PropertyType from constraints and drop everything else, so a hint
        // here would never reach the editor. It decides nothing about
        // validity — a link that holds a value is classified by the value.
        constraints:
            descriptor.initialLinkKind == null
                ? const {}
                : {
                  LinkPropertyType.defaultKindConstraint:
                      descriptor.initialLinkKind!.name,
                },
        createdAt: now,
        updatedAt: now,
      ),
    );

    // The resolved-type map is a Future provider reading the file we just
    // wrote, so it has to be re-read for the new property to render as its
    // type rather than as plain text.
    ref.invalidate(propertyTypesForLabelsProvider);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdding) {
      return TextButton.icon(
        onPressed: _start,
        icon: Icon(FondeIcons.plus, size: 16.0),
        label: AppText('Add Property', variant: AppTextVariant.bodyText),
        style: TextButton.styleFrom(
          foregroundColor: widget.colorScheme.base.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: FondeTextField(
                controller: _controller,
                focusNode: _focusNode,
                hintText: 'Property name',
                onSubmitted: (_) => _commit(),
              ),
            ),
            IconButton(
              icon: Icon(FondeIcons.check),
              iconSize: 16.0,
              tooltip: 'Add',
              onPressed: _commit,
              color: widget.colorScheme.base.foreground,
            ),
            IconButton(
              icon: Icon(FondeIcons.x),
              iconSize: 16.0,
              tooltip: 'Cancel',
              onPressed: _cancel,
              color: widget.colorScheme.base.foreground,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // The type is chosen up front rather than changed afterwards: it
        // decides how the value field is rendered, so picking it after typing
        // a value would mean re-rendering the field under the user.
        Row(
          children: [
            AppText(
              'Type',
              variant: AppTextVariant.captionText,
              color: widget.colorScheme.base.foreground.withAlpha(180),
            ),
            const SizedBox(width: 8),
            FondeDropdownMenu<String>(
              initialSelection: _pickerId,
              dropdownMenuEntries: [
                for (final descriptor in PropertyTypeRegistry.selectable)
                  DropdownMenuEntry(
                    value: descriptor.pickerId,
                    label: descriptor.label,
                  ),
              ],
              onSelected: (value) {
                if (value == null) return;
                setState(() => _pickerId = value);
              },
            ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: AppText(
              _error!,
              variant: AppTextVariant.captionText,
              color: widget.colorScheme.status.error,
            ),
          ),
      ],
    );
  }
}

/// Property name editor widget
class _PropertyNameEditorWidget extends StatefulWidget {
  const _PropertyNameEditorWidget({
    super.key,
    required this.propertyKey,
    required this.editingName,
    required this.colorScheme,
    required this.onFinish,
  });

  final String propertyKey;
  final String editingName;
  final AppColorScheme colorScheme;
  final ValueChanged<String> onFinish;

  @override
  State<_PropertyNameEditorWidget> createState() =>
      _PropertyNameEditorWidgetState();
}

class _PropertyNameEditorWidgetState extends State<_PropertyNameEditorWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  /// Guards against committing twice.
  ///
  /// Enter fires onSubmitted and then drops focus, so without this the name
  /// would be committed a second time on the way out.
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    print('[PropertyNameEditor] initState: ${widget.propertyKey}');
    _controller = TextEditingController(text: widget.editingName);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _focusNode.requestFocus();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus || _finished) return;
    print(
      '[PropertyNameEditor] Focus lost: ${widget.propertyKey}, '
      'text=${_controller.text}',
    );
    _finished = true;
    widget.onFinish(_controller.text);
  }

  void _finish(String newName) {
    if (_finished) return;
    _finished = true;
    widget.onFinish(newName);
  }

  @override
  void dispose() {
    print('[PropertyNameEditor] dispose: ${widget.propertyKey}');
    _focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[PropertyNameEditor] build: ${widget.propertyKey}');
    // The node belongs to the TextField alone. Handing the same node to a
    // surrounding Focus made the framework reparent the node under itself —
    // "Tried to make a child into a parent of itself" — which took the whole
    // panel down as soon as a property name was clicked. Listening to the
    // node directly gives the same commit-on-blur behaviour without a second
    // widget claiming it.
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onSubmitted: (newName) {
        print(
          '[PropertyNameEditor] Enter pressed: ${widget.propertyKey}, newName=$newName',
        );
        _finish(newName);
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: widget.colorScheme.base.divider,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: widget.colorScheme.base.selection,
            width: 1.5,
          ),
        ),
      ),
      style: TextStyle(
        color: widget.colorScheme.base.foreground,
        fontSize: 12.0,
      ),
      // No autofocus: initState already requests focus on this node, and
      // asking twice makes the field claim focus again on every rebuild.
    );
  }
}
