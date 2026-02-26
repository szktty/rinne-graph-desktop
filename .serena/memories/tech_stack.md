The project is built with:
- Application Framework: Flutter (version >=3.41.2)
- Programming Language: Dart (version ^3.7.0)
- Monorepo Management: Melos (version ^7.0.0-dev.9)
- Documentation Website: Rspress
- Scripting: Shell scripts, Dart utilities

Key dependencies include:
- freezed_annotation: ^3.0.0 (freezed 3.x - major update)
- flutter_riverpod: ^3.0.0 (riverpod 3.x - major update)
- riverpod_annotation: ^4.0.0
- intl: ^0.19.0
- json_annotation: ^4.9.0
- go_router: ^14.6.3
- shared_preferences: ^2.2.2
- lucide_icons_flutter: ^3.0.5
- macos_ui: ^2.1.9
- uuid: ^4.5.1
- path_provider: ^2.1.5
- appkit_ui_element_colors: ^1.0.1
- flutter_desktop_context_menu: ^0.2.0
- email_validator: ^3.0.0

Dev dependencies include:
- build_runner, very_good_analysis, custom_lint, riverpod_generator: ^4.0.0, riverpod_lint, freezed: ^3.0.0, json_serializable, test, kiri_check, flutter_gen_runner, flutter_lints.

Important version notes:
- freezed and riverpod have undergone MAJOR version upgrades (freezed 3.x, riverpod 3.x).
  Code generation patterns and API may differ from previous versions.
- Always run `melos run gen:all` after modifying freezed or riverpod annotated code.
