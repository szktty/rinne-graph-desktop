- Follow Flutter/Dart official style guides and best practices.
- All code must be formatted using `dart format .`.
- Write clear, concise, and self-documenting code.
- Add comments sparingly, focusing on *why* complex logic exists.
- All text (source code, comments, documentation) must be in English.
- Strictly follow existing project conventions (naming, formatting, architecture).

Linter rules:
- Includes `package:flutter_lints/flutter.yaml`.
- Excludes generated files (`.g.dart`, `.freezed.dart`, `generated/`) and `test/` directory from analysis.
- Ignores `todo`, `invalid_annotation_target`, and `deprecated_member_use` errors.
- `avoid_print`: Disabled.
- `deprecated_member_use_from_same_package`: Ignored.