# 04. Implementation Guide

## 💻 Implementation Guidelines

### 🏗️ Basic Implementation Patterns

#### Using Riverpod Providers

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Recommended: Get theme information from provider
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final themeData = ref.watch(effectiveThemeDataProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    
    return AppContainer(
      color:appColorScheme.surface,
      child: AppText(
        'Text',
        variant: AppTextVariant.uiBody,
      ),
    );
  }
}
```

#### Implementing Accessibility Support

```dart
// ✅ Recommended: Implementing zoom support
class AccessibleWidget extends ConsumerWidget {
  final bool disableZoom;
  
  const AccessibleWidget({required this.child, this.disableZoom = false});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : config.zoomScale;
    final borderScale = disableZoom ? 1.0 : config.borderScale;
    
    return Container(
      padding: EdgeInsets.all(16.0 * zoomScale),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5 * borderScale,
          color:appColorScheme.containerBorder,
        ),
      ),
      child: child,
    );
  }
}
```

### 🎨 Best Practices for Color Usage

```dart
// ❌ Avoid: Hardcoding
Container(
  color: Colors.blue,
  child: Text(
    'Text',
    style: TextStyle(color: Colors.white),
  ),
)

// ❌ Avoid: Direct ColorScheme reference
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text('Text'),
)

// ✅ Recommended: appColorScheme + AppText
AppContainer(
  color:appColorScheme.surface,
  child: AppText(
    'Text',
    variant: AppTextVariant.uiBody,
  ),
)

// ✅ Recommended: Semantic color usage
Container(
  color:appColorScheme.notificationSuccess,  // Success state
  child: AppText(
    'Saved',
    variant: AppTextVariant.uiCaption,
    color:appColorScheme.onSurface,
  ),
)
```

### 📝 Best Practices for Text Usage

```dart
// ❌ Avoid: Direct use of Flutter's standard Text
Text(
  'Button Label',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
)

// ✅ Recommended: Using AppTextVariant
AppText(
  'Button Label',
  variant: AppTextVariant.uiBody,
)

// ✅ Recommended: Using shortcut widgets
UiBodyText('Button Label')

// ✅ Recommended: When custom color is needed
AppText(
  'Error Message',
  variant: AppTextVariant.uiCaption,
  color:appColorScheme.notificationError,
)
```

### 🔲 Best Practices for Rounded Corner Implementation

**All rounded corner elements should use `AppRectangleBorder`:**

```dart
// ❌ Avoid: Direct BorderRadius usage
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(imageUrl),
  ),
)

// ✅ Recommended: Using AppRectangleBorder (predefined values)
AppRectangleBorder(
  cornerRadius: AppBorderRadiusValues.medium, // 12px
  color: colorScheme.surface,
  side: BorderSide(color: colorScheme.border),
  child: Image.network(imageUrl),
)

// ✅ Recommended: Using AppBorderRadius class
AppRectangleBorder.medium(
  color: colorScheme.surface,
  side: BorderSide(color: colorScheme.border),
  child: Image.network(imageUrl),
)

// ✅ Recommended: Unified styling using provider
Consumer(
  builder: (context, ref, child) {
    final decoration = ref.watch(appShapeDecorationProvider(
      color: colorScheme.surface,
      cornerRadius: AppBorderRadiusValues.medium,
    ));

    return Container(
      decoration: decoration,
      child: child,
    );
  },
)
```

#### Key Properties of AppRectangleBorder

| Property | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `double?` | `12.0` | Corner radius (recommends `AppBorderRadiusValues`) |
| `cornerSmoothing` | `double?` | `0.6` | Corner smoothness (fixed value, unchangeable) |
| `side` | `BorderSide?` | `BorderSide(color: containerBorder, width: 1.5)` | Border style |
| `color` | `Color?` | `null` | Background color |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding |

#### Available Rounded Corner Values

| Constant | Value | Purpose |
|---|---|---|
| `AppBorderRadiusValues.small` | 6px | Small elements |
| `AppBorderRadiusValues.medium` | 12px | Standard elements |
| `AppBorderRadiusValues.large` | 16px | Large elements |
| `AppBorderRadiusValues.xlarge` | 24px | Containers, dialogs |

### 🏗️ Best Practices for Layout Implementation

```dart
// ❌ Avoid: Direct use of Flutter's standard widgets
Column(
  children: [
    Text('Title', style: TextStyle(fontSize: 24)),
    SizedBox(height: 16), // Hardcoding
    Padding(
      padding: EdgeInsets.all(15), // 4px grid violation
      child: Container(child: content), // Design guideline non-compliant
    ),
    SizedBox(height: 25), // 4px grid violation
  ],
)

// ✅ Recommended: Using token-based spacing
Column(
  children: [
    UiHeading2Text('Title'),
    AppSpacing.verticalLg,        // 16px
    Container(
      padding: AppPadding.lg,     // 16px
      child: content,
    ),
    AppSpacing.verticalXxl,       // 24px
  ],
)
```

### 🔲 Proper Implementation of Separator Lines

```dart
// ❌ Avoid: Direct placement without spacing
Column(
  children: [
    Widget1(),
    Divider(), // Flutter standard Divider + no spacing
    Widget2(),
  ],
)

// ❌ Avoid: AppDivider without spacing either
Column(
  children: [
    Widget1(),
    AppDivider(), // No spacing is visually too dense
    Widget2(),
  ],
)

// ✅ Recommended: Using Section component
Section(
  showDividers: true,
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)

// ✅ Recommended: Proper spacing in manual layout
Column(
  children: [
    Widget1(),
    AppSpacing.verticalLg,    // 16px
    AppDivider(),
    AppSpacing.verticalLg,    // 16px
    Widget2(),
  ],
)

// ✅ Recommended: Directional spacing
Container(
  padding: EdgeInsets.only(
    left: AppPadding.lg.left,     // 16px
    right: AppPadding.lg.right,   // 16px
    top: AppPadding.md.top,       // 12px
    bottom: AppPadding.md.bottom, // 12px
  ),
  child: SettingsContent(),
)
```

## 🎯 Best Practices

### 🎨 Leveraging the Design System

1.  **Maintaining Consistency**
    - Prioritize existing components
    - Use values based on design tokens
    - Obtain theme information via provider

2.  **Accessibility First**
    - Implement zoom support for all components
    - Provide appropriate Semantics information
    - Support keyboard navigation

3.  **Performance Optimization**
    - Avoid unnecessary rebuilds
    - Efficient provider usage
    - Utilize `const` constructors

### 🔧 Component Development

```dart
// ✅ Recommended: Basic structure of a new component
class MyNewComponent extends ConsumerWidget {
  final String label;
  final VoidCallback? onTap;
  final bool disableZoom;
  
  const MyNewComponent({
    super.key,
    required this.label,
    this.onTap,
    this.disableZoom = false,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    
    return Semantics(
      button: true,
      label: label,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.0 * zoomScale),
          decoration: BoxDecoration(
            color:appColorScheme.surface,
            borderRadius: BorderRadius.circular(8.0 * zoomScale),
          ),
          child: AppText(
            label,
            variant: AppTextVariant.uiBody,
          ),
        ),
      ),
    );
  }
}
```

### 🎭 State Management

```dart
// ✅ Recommended: Using Riverpod StateProvider
final selectedItemProvider = StateProvider<String?>((ref) => null);

class SelectableItem extends ConsumerWidget {
  final String itemId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedItemProvider);
    final isSelected = selectedId == itemId;
    
    return SelectableCard(
      isSelected: isSelected,
      onTap: () => ref.read(selectedItemProvider.notifier).state = itemId,
      child: ItemContent(...),
    );
  }
}
```

## 🚨 Common Mistakes

### ❌ Anti-Patterns

#### 1. Avoiding the Theme System

```dart
// ❌ Bad example: Hardcoding
Container(
  color: Color(0xFF1976D2),
  padding: EdgeInsets.all(15),
  child: Text(
    'Button',
    style: TextStyle(color: Colors.white, fontSize: 16),
  ),
)

// ✅ Good example: Leveraging the design system
AppButton(
  label: 'Button',
  onPressed: () {},
)
```

#### 2. Neglecting Accessibility

```dart
// ❌ Bad example: No zoom support, grid violation
Container(
  width: 200,
  height: 50,
  padding: EdgeInsets.all(8),  // 4px grid violation
  child: Text('Fixed Size'),     // Typography violation
)

// ✅ Good example: Accessibility compliant
class AccessibleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(accessibilityConfigProvider);
    return Container(
      padding: AppPadding.md.scale(config.zoomScale),
      child: AppText(
        'Responsive Text',
        variant: AppTextVariant.uiBody,
      ),
    );
  }
}
```

#### 3. Ignoring the Grid System

```dart
// ❌ Bad example: 4px grid violation
Column(
  children: [
    SizedBox(height: 15),        // 4px violation
    Padding(
      padding: EdgeInsets.all(10), // 4px violation
      child: Text('Content'),
    ),
    SizedBox(height: 25),        // 4px violation
  ],
)

// ✅ Good example: Using predefined tokens
Column(
  children: [
    AppSpacing.verticalLg,     // 16px
    Container(
      padding: AppPadding.md,  // 12px
      child: UiBodyText('Content'),
    ),
    AppSpacing.verticalXxl,    // 24px
  ],
)
```

## 📁 Implementing File Dialogs

### 🎯 Unified Specification for Initial Directory

The initial directory for file dialogs (file selection/saving) is determined by the following priority for consistent user experience:

#### Priority
1.  **Last opened directory** - Directory used in the previous file operation
2.  **User-specific directory** - RinneGraph's dedicated directory within the user's home directory (e.g., `~/Documents/RinneGraph/`)

#### Applicable to
- ✅ Selecting save location when creating a new stack
- ✅ Selecting file when opening an existing stack
- ✅ Selecting file when importing data
- ✅ Selecting save location when exporting data
- ✅ All other file operation dialogs

#### Implementation Pattern

```dart
// ✅ Recommended: Using a unified file dialog service
class FileDialogService {
  static String? _lastUsedDirectory;

  /// Get initial directory
  static Future<String> getInitialDirectory() async {
    // 1. Prioritize last opened directory
    if (_lastUsedDirectory != null && await Directory(_lastUsedDirectory!).exists()) {
      return _lastUsedDirectory!;
    }

    // 2. Fallback to user-specific directory
    return await getUserSpecificDirectory();
  }

  /// Display file selection dialog
  static Future<String?> pickFile({
    String? dialogTitle,
    List<String>? allowedExtensions,
  }) async {
    final initialDirectory = await getInitialDirectory();

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      allowedExtensions: allowedExtensions,
      initialDirectory: initialDirectory,
    );

    // Remember the directory of the selected file
    if (result?.files.first.path != null) {
      _lastUsedDirectory = path.dirname(result!.files.first.path!)
    }

    return result?.files.first.path;
  }
}
```

#### Setting Persistence

```dart
// ✅ Recommended: Save last directory with SharedPreferences
class DirectoryPreferences {
  static const String _lastDirectoryKey = 'last_used_directory';

  static Future<void> saveLastDirectory(String directory) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDirectoryKey, directory);
  }

  static Future<String?> getLastDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDirectoryKey);
  }
}
```

#### Example Usage

```dart
// ✅ Good example: Using unified service
Future<void> openStackDialog() async {
  final stackPath = await FileDialogService.pickFile(
    dialogTitle: 'Select Stack File',
    allowedExtensions: ['app_desktop'],
  );

  if (stackPath != null) {
    // Process to open stack
  }
}

// ❌ Avoid: Direct FilePicker usage (initial directory not unified)
Future<void> openStackDialogBad() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['app_desktop'],
    // initialDirectory is not specified
  );
}
```

### 💡 Implementation Points

- **Consistency**: Use the same initial directory logic for all file dialogs
- **Memory Function**: Remember user's last operation to improve UX
- **Fallback**: Appropriate alternative if the last directory does not exist
- **Platform Support**: Consider OS-specific directory structures

## 🗂️ Stack Naming Conventions and File Structure

RinneGraph's stacks adopt a file structure similar to macOS "packages" or "bundles" to balance intuitive user operation with development robustness.

#### Basic Specification

1.  **User Input (Display Name)**
    - When creating a new stack, users can freely enter a stack name (e.g., `My Awesome Project`, `Research/Data`).
    - This name is treated as the **Display Name** and is always shown in the app's UI.

2.  **Physical Entity on File System (Package)**
    - The display name entered by the user is **sanitized** into a safe name for the file system.
        - **Sanitization rules**:
            - Spaces are replaced with hyphens `-`.
            - Path separators (`/`, `\`) are replaced with underscores `_`.
            - Other special characters not allowed by the OS are removed.
        - Example: `My Awesome Project` → `My-Awesome-Project`
    - A **directory** is created with the sanitized name and a `.stack` extension is appended. This becomes the physical entity (package) of the stack.
        - Example: `My-Awesome-Project.stack/`
    - This package behaves like a single file in macOS Finder.

3.  **Internal Structure and Metadata**
    - Inside the `.stack` package, graph data, assets, and metadata files (e.g., `metadata.json`) are stored.
    - The metadata file must always save the original display name entered by the user under a key like `"displayName"`.

    ```json
    // Example of My-Awesome-Project.stack/metadata.json
    {
      "displayName": "My Awesome Project",
      "createdAt": "2025-07-07T12:00:00Z",
      // ...other metadata
    }
    ```

#### Implementation Points

- **`FileSystemService` Role**: `createStackDirectory` is responsible for receiving the display name, sanitizing it, and creating the `.stack` package.
- **Displaying Stack Name**: The application must always read and display the `displayName` from the metadata inside the package, not the file system name (e.g., `My-Awesome-Project`).
- **Robustness**: This design ensures that users do not need to worry about using special characters in filenames, and developers can work with safe paths.

## 🗂️ FileSystemService API

### 🎯 Overview

`FileSystemService` abstracts file system operations used throughout the application, providing a consistent API. It implements the directory structure defined in the [File System Specification](../../architecture/file_system.md).

### 📁 Directory Retrieval API

#### Basic Directories

```dart
// ✅ User-specific directory (recommended)
// Path example: ~/Documents/RinneGraph/ (macOS non-sandbox)
//        ~/Library/Containers/.../Data/Documents/RinneGraph/ (macOS sandbox)
final userDir = await FileSystemService().getUserSpecificDirectory();

// ✅ Stack storage directory (default save location)
// Path: {User-specific directory}/Stacks/
final stacksDir = await FileSystemService().getStackStorageDirectory();

// ✅ Application settings directory (platform-specific)
// Path example: ~/Library/Application Support/RinneGraph/ (macOS)
//        %APPDATA%\RinneGraph\ (Windows)
final settingsDir = await FileSystemService().getApplicationSettingsDirectory();

// ✅ RinneGraph dedicated temporary directory
// Path example: ~/Library/Caches/RinneGraph/ (macOS)
//        %TEMP%\RinneGraph\ (Windows)
final tempDir = await FileSystemService().getAppTemporaryDirectory();

// ❌ Deprecated (retained for backward compatibility)
final deprecatedDir = await FileSystemService().getApplicationDocumentsDirectory();
```

#### Data Processing Directories

```dart
// ✅ Export directory
// Path: {User-specific directory}/Exports/
final exportsDir = await FileSystemService().getExportsDirectory();

// ✅ Import directory
// Path: {User-specific directory}/Imports/
final importsDir = await FileSystemService().getImportsDirectory();
```

#### Settings, Cache, and Log Directories

```dart
// ✅ Preferences directory
final preferencesDir = await FileSystemService().getPreferencesDirectory();

// ✅ Cache directory (XDG compliant on Linux)
final cacheDir = await FileSystemService().getCacheDirectory();

// ✅ Logs directory
final logsDir = await FileSystemService().getLogsDirectory();
```

### 📦 Stack-Related API

#### Creating and Managing Stack Directories

```dart
// ✅ Create stack directory (automatically appends .stack extension)
final stackDir = await FileSystemService().createStackDirectory('MyProject');
// Result: ~/Documents/RinneGraph/Stacks/MyProject.stack/

// ✅ Create stack directory at any location
final customStackDir = await FileSystemService().createStackDirectory(
  'Research',
  '/path/to/user/projects'
);
// Result: /path/to/user/projects/Research.stack/

// ✅ Check if it is a stack directory
final isStack = FileSystemService().isStackDirectory(someDirectory);

// ✅ Get stack name (removes .stack extension)
final stackName = FileSystemService().getStackName(stackDirectory);
// Example: 'MyProject.stack' → 'MyProject'
```

#### Searching for Stack Directories

```dart
// ✅ Search for stack directories within a specified directory
final stackDirs = await FileSystemService().findStackDirectories('/path/to/search');

// ✅ Search within the default stack storage directory
final defaultStacksDir = await FileSystemService().getStackStorageDirectory();
final foundStacks = await FileSystemService().findStackDirectories(defaultStacksDir.path);
```

### ⚙️ Settings File-Related API

#### Getting Settings File Paths

```dart
// ✅ Application settings file
final appSettingsFile = await FileSystemService().getAppSettingsFile();
// Result: ~/.../preferences/app_settings.json

// ✅ UI preferences file
final uiPrefsFile = await FileSystemService().getUIPreferencesFile();
// Result: ~/.../preferences/ui_preferences.json

// ✅ Recent files setting
final recentFilesFile = await FileSystemService().getRecentFilesFile();
// Result: ~/.../preferences/recent_files.json

// ✅ Log file
final appLogFile = await FileSystemService().getLogFile('app.log');
final errorLogFile = await FileSystemService().getLogFile('error.log');
```

### 🔧 Best Practices for Implementation

#### ✅ Recommended Pattern

```dart
class StackManager {
  final FileSystemService _fileSystem = FileSystemService();

  Future<void> createNewStack(String name, [String? customPath]) async {
    try {
      // Create stack directory using FileSystemService
      final stackDir = await _fileSystem.createStackDirectory(name, customPath);

      // Initialize stack internal structure
      await _initializeStackStructure(stackDir);

    } on FileSystemException catch (e) {
      // Appropriate error handling
      throw StackCreationException('Failed to create stack: ${e.message}');
    }
  }

  Future<List<String>> getAvailableStacks() async {
    final stacksDir = await _fileSystem.getStackStorageDirectory();
    final stackDirs = await _fileSystem.findStackDirectories(stacksDir.path);

    return stackDirs.map((dir) => _fileSystem.getStackName(dir)).toList();
  }
}
```

#### ❌ Patterns to Avoid

```dart
// ❌ Direct path manipulation (platform-dependent, prone to errors)
class BadStackManager {
  Future<void> createNewStackBad(String name) async {
    // Hardcoded path (macOS specific)
    final stackPath = '/path/to/documents/RinneGraph/Stacks/$name.stack';
    final stackDir = Directory(stackPath);

    // No error handling, no existence check
    await stackDir.create(recursive: true);
  }
}
```

### 🌐 Platform Compatibility

FileSystemService uses the following packages to ensure reliable path operations:

- **`path_provider`**: Supports iOS, Android, Windows, macOS
- **`xdg_directories`**: Compliant with Linux XDG Base Directory Specification
- **Appropriate fallbacks**: Alternatives if environment variables cannot be retrieved

### 🚀 Initialization API

#### Initialization-Related Methods

```dart
// ✅ Initialize user-specific directories
// Returns: true on success, false on failure
final success = await FileSystemService().initializeUserSpecificDirectories();

// ✅ Check initialization status
// Returns: true if all directories exist
final isInitialized = await FileSystemService().isUserSpecificDirectoriesInitialized();

// ✅ Get directory information (for debugging)
// Returns: Directory path information in Map<String, String> format
final directoryInfo = await FileSystemService().getUserSpecificDirectoryInfo();
```

#### Application Startup Initialization

```dart
// ✅ Initialize user-specific directories on application startup
final fileSystem = FileSystemService();
final success = await fileSystem.initializeUserSpecificDirectories();

if (success) {
  print('Directory initialization complete');
} else {
  print('Directory initialization failed');
}

// ✅ Check initialization status
final isInitialized = await fileSystem.isUserSpecificDirectoriesInitialized();

// ✅ Get directory information (for debugging)
final directoryInfo = await fileSystem.getUserSpecificDirectoryInfo();
directoryInfo.forEach((key, value) {
  print('$key: $value');
});
```

#### Directories to be Initialized (9 types)

`initializeUserSpecificDirectories()` automatically creates the following directories:

1.  **User-specific directory**: Main RinneGraph directory
2.  **Stack storage directory**: Location for `.stack` files
3.  **Export directory**: Save location for data exports
4.  **Import directory**: Temporary storage for data imports
5.  **Application settings directory**: Platform-specific settings directory
6.  **Preferences directory**: For application settings files
7.  **Cache directory**: For temporary cache files
8.  **Logs directory**: For application logs
9.  **Temporary directory**: For temporary files

#### Automatic Initialization Mechanism

FileSystemService is automatically executed during the initialization process of the `core_foundation` package:

```dart
// packages/core/foundation/lib/src/package/initialization.dart
final coreFoundationInitialization = PackageInitialization(
  initialize: (ref) async {
    // Initialize user-specific directories
    await _initializeUserSpecificDirectories();
  },
);
```

#### Created Directory Structure

##### macOS (Sandbox Environment)
```
~/Library/Containers/com.example.desktop/Data/Documents/RinneGraph/
├── Stacks/           # For stack storage
├── Exports/          # For exports
└── Imports/          # For imports

~/Library/Containers/com.example.desktop/Data/Library/Application Support/com.example.desktop/RinneGraph/
├── preferences/      # For settings files
├── cache/           # For cache
└── logs/            # For log files

~/Library/Containers/com.example.desktop/Data/Library/Caches/RinneGraph/
                     # For temporary files
```

##### macOS (Non-Sandbox Environment)
```
~/Documents/RinneGraph/
├── Stacks/           # For stack storage
├── Exports/          # For exports
└── Imports/          # For imports

~/Library/Application Support/RinneGraph/
├── preferences/      # For settings files
├── cache/           # For cache
└── logs/            # For log files

~/Library/Caches/RinneGraph/
                     # For temporary files
```

##### Windows
```
%USERPROFILE%\Documents\RinneGraph\
├── Stacks\           # For stack storage
├── Exports\          # For exports
└── Imports\          # For imports

%APPDATA%\RinneGraph\
├── preferences\      # For settings files
├── cache\           # For cache
└── logs\            # For log files

%TEMP%\RinneGraph\       # For temporary files
```

##### Linux
```
~/Documents/RinneGraph/
├── Stacks/           # For stack storage
├── Exports/          # For exports
└── Imports/          # For imports

~/.config/RinneGraph/
├── preferences/      # For settings files
├── cache/           # For cache (XDG_CACHE_HOME compliant)
└── logs/            # For log files

/tmp/RinneGraph/         # For temporary files
```

### 🌐 Platform Compatibility

#### Packages Used

- **`path_provider`**: Standard directory retrieval across platforms
- **`xdg_directories`**: Compliant with XDG Base Directory Specification in Linux environments

#### Platform-Specific Path Resolution

##### macOS
- **Sandbox environment**: Uses `path_provider` (recommended)
- **Non-sandbox environment**: Uses actual home directory from `HOME` environment variable
- **Automatic detection**: Detects sandbox environment by the presence of `Library/Containers` path

##### Windows
- **Standard**: Uses actual user directory from `USERPROFILE` environment variable
- **Fallback**: Uses `path_provider`

##### Linux
- **XDG compliant**: Prioritizes `xdg_directories` package
- **Fallback**: Uses `HOME` environment variable

#### Detailed Log Output

The following information is output to debug logs on each platform:
- Environment variable values (HOME, USERPROFILE, etc.)
- Directory paths used
- Sandbox environment detection results
- Directory creation/existence check results

#### Reliability

Using external packages prevents platform-specific implementation errors and allows for future specification changes.

#### Fallback

Provides alternatives using `path_provider` even if environment variables fail to retrieve.

### 💡 Notes on Usage

- **Automatic directory creation**: All directory retrieval APIs automatically create directories as needed
- **Exception handling**: `createStackDirectory` throws `FileSystemException` if the directory already exists
- **Path separators**: Platform differences are handled automatically
- **Backward compatibility**: `getApplicationDocumentsDirectory()` is deprecated but retained for compatibility
- **Initialization**: Directory structure is automatically created on app startup
- **Sandbox support**: Appropriate paths are automatically selected in macOS sandbox environment

---

**📍 Navigation**: [← Back](./03-components.md) | [Next: Accessibility →](./05-accessibility.md)