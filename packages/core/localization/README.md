# core_localization

## Overview

core_localization provides comprehensive localization support for the App application. It uses Flutter's built-in l10n system with ARB (Application Resource Bundle) files to support multiple languages, currently Japanese and English.

## Key Features

- **Multi-language Support**: Japanese (ja) and English (en)
- **700+ Localization Strings**: Comprehensive coverage for UI, menus, errors, and validation messages
- **ARB File Format**: Standard Flutter localization format for easy maintenance
- **Riverpod Integration**: Locale management via providers
- **Type-safe Access**: Generated `AppLocalizations` class for compile-time safety
- **Automatic Locale Detection**: Respects system locale settings

## Supported Languages

- **Japanese (ja)**: Primary language with complete translations
- **English (en)**: Full English translations

## Usage

### Basic Usage

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In a widget
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(l10n.appTitle);
  }
}

// With Riverpod
class MyConsumerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(currentLocaleProvider);
    final l10n = AppLocalizations.of(context)!;
    return Text(l10n.appTitle);
  }
}
```

### Configuration

The localization system is configured in `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_ja.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

## ARB File Structure

- `app_ja.arb`: Japanese translations (template)
- `app_en.arb`: English translations

Each file contains key-value pairs for all UI strings.

## Dependencies

- `intl`: Internationalization support
- `flutter_riverpod`: Locale management

## Related Documentation

- [Riverpod Providers Reference](../../docs/development/riverpod-providers-reference.md)

