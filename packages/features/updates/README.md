# features_updates

A package that provides version update checking functionality for the App application.

## Features

- **Version Comparison**: Version comparison based on semantic versioning (semver)
- **GitHub Tag Retrieval**: Retrieve release tags from GitHub repository
- **Update Checking**: Compare current version with latest version to determine if updates are available
- **Update Check UI**: User-friendly update check dialog

## Usage

### Version Comparison

```dart
import 'package:features_updates/updates.dart';

// Parse versions
final v1 = Version.parse('1.2.3');
final v2 = Version.parse('2.0.0');

// Compare versions
if (v2.isNewerThan(v1)) {
  print('v2 is newer than v1');
}

// Pre-release version
final preRelease = Version.parse('1.0.0-alpha');
final stable = Version.parse('1.0.0');

// No pre-release > with pre-release
print(stable.isNewerThan(preRelease)); // true
```

### Checking for Updates from GitHub

```dart
import 'package:features_updates/updates.dart';

// Create version checker
final checker = VersionChecker(
  owner: 'szktty',
  repo: 'rinne_graph_desktop',
);

// Compare with current version
final result = await checker.checkForUpdates('1.0.0');

if (result.updateAvailable) {
  print('New version available: ${result.latestVersion}');
} else if (result.errorMessage != null) {
  print('Error: ${result.errorMessage}');
} else {
  print('You are using the latest version');
}
```

### Display Update Check Dialog

```dart
import 'package:features_updates/updates.dart';

// Display dialog
await showUpdateCheckDialog(context);
```

## Version Format

This package supports the following version formats:

- `1.2.3` - Basic semantic versioning
- `v1.2.3` - With v prefix (common in GitHub tags)
- `1.2.3-alpha` - With pre-release identifier
- `1.2.3-beta.1` - With multi-segment pre-release identifier
- `1.2.3+build.123` - With build metadata
- `1.2.3-alpha+build.123` - Combination of pre-release and build metadata

## Version Comparison Rules

1. **Major.Minor.Patch**: Compared as numbers
2. **Pre-release**: No pre-release > with pre-release
3. **Pre-release Identifier**: Compared alphabetically
4. **Build Metadata**: Does not affect comparison

## Testing

Version comparison logic is covered by comprehensive unit tests:

```bash
cd packages/features/updates
flutter test
```

## Notes

- Tag retrieval will fail if the GitHub repository is not public
- Pre-release versions (e.g., `1.0.0-alpha`) are excluded from latest version determination
- Be aware of GitHub rate limits (60 requests per hour without authentication)

## Planned Extensions

- [ ] GitHub authentication token support
- [ ] Automatic update download functionality
- [ ] Display release notes
- [ ] Automatic update check scheduling

