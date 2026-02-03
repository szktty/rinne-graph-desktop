# RinneGraph Desktop Application Architecture

This document provides a key architectural overview of the RinneGraph desktop application and detailed implementation guidelines for developing new features and screens.

## Architecture Overview

### MainShellLayout and MainAppShell

**Important**: In this application, `MainAppShell` already manages the overall application layout using `MainShellLayout`. When implementing new screens, please utilize `MainAppShell`'s existing 3-pane configuration instead of creating your own `MainShellLayout`.

#### Application Structure
```
MainAppShell (using MainShellLayout)
├── ActivityBar (Leftmost)
├── PrimarySidebar (Left)
├── MainContent (Center)
└── SecondarySidebar (Right, conditionally displayed)
```

## How to Implement New Screens

### 1. Basic Screen Implementation

New screens are displayed as `content` within `MainAppShell`:

```dart
/// Example of a new screen
class MyNewScreen extends ConsumerWidget {
  const MyNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Toolbar (if necessary)
        const MyScreenToolbar(),

        // Main content
        const Expanded(
          child: MyScreenContent(),
        ),
      ],
    );
  }
}
```

### 2. Registering Content and Sidebars (ContentBuilder and SidebarBuilder)

To add a new screen, changes are made to `ContentBuilder` and `SidebarBuilder`, which are referenced from `MainAppShell`. This displays the main content area, primary sidebar, and, if necessary, the secondary sidebar.

#### a) Adding Main Content (`ContentBuilder`)

Add the display logic for the new screen to the `build` method within the `ContentBuilder` class. Return the appropriate screen widget based on the selected activity.

```dart
// apps/desktop/lib/src/widgets/shell/main_content_builder.dart
class ContentBuilder extends ConsumerWidget {
  final AppActivityItemType selectedActivityItem;

  const ContentBuilder(this.selectedActivityItem, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (selectedActivityItem) {
      case AppActivityItemType.myNewScreen: // New activity type
        return const MyNewScreen(); // New screen widget
      // Existing cases...
      default:
        return const Center(child: Text('Unknown Activity'));
    }
  }
}
```

#### b) Adding Primary Sidebar (`SidebarBuilder`)

Add the logic for the primary sidebar corresponding to the new screen to the `buildPrimarySidebar` method within the `SidebarBuilder` class.

```dart
// apps/desktop/lib/src/widgets/shell/sidebar_builder.dart
class SidebarBuilder extends ConsumerWidget {
  final AppActivityItemType selectedActivityItem;

  const SidebarBuilder(this.selectedActivityItem, {super.key});

  @override
  Widget buildPrimarySidebar(BuildContext context, WidgetRef ref) {
    switch (selectedActivityItem) {
      case AppActivityItemType.myNewScreen: // New activity type
        return const MyScreenSidebar(); // New sidebar widget
      // Existing cases...
      default:
        return const SizedBox.shrink();
    }
  }
  // ...
}
```

#### c) Adding Secondary Sidebar (`SidebarBuilder`) (if necessary)

Add the logic for the secondary sidebar corresponding to the new screen to the `buildSecondarySidebar` method within the `SidebarBuilder` class. This is typically used to display details of an item selected in the main content.

```dart
// apps/desktop/lib/src/widgets/shell/sidebar_builder.dart
class SidebarBuilder extends ConsumerWidget {
  final AppActivityItemType selectedActivityItem;

  const SidebarBuilder(this.selectedActivityItem, {super.key});

  @override
  Widget buildSecondarySidebar(BuildContext context, WidgetRef ref) {
    switch (selectedActivityItem) {
      case AppActivityItemType.myNewScreen: // New activity type
        return Consumer(
          builder: (context, ref, child) {
            final selectedItem = ref.watch(mySelectedItemProvider);
            if (selectedItem != null) {
              return const Sidebar(child: MyItemEditor());
            }
            return const SizedBox.shrink();
          },
        );
      // Existing cases...
      default:
        return const SizedBox.shrink();
    }
  }
  // ...
}
```

### 3. Implementation Example: Label List Screen

Please refer to the implementation of the label list screen:

- **Screen**: `LabelListScreen` - Simple configuration with toolbar + table view
- **Primary Sidebar**: `LabelListSidebar` - Quick access navigation
- **Secondary Sidebar**: `LabelEditorSidebar` - Editor screen for selected labels
- **Dynamic Display**: Secondary sidebar displayed/hidden depending on selection state

### 4. Package Configuration

New features should be placed in appropriate packages:

- **Screens**: `packages/features/[feature_name]/lib/src/screens/`
- **Widgets**: `packages/features/[feature_name]/lib/src/widgets/`
- **Providers**: `packages/features/[feature_name]/lib/src/providers/`
- **Exports**: `packages/features/[feature_name]/lib/[feature_name].dart`

### 5. Important Notes

#### ❌ What NOT to do
```dart
// Creating your own MainShellLayout (will result in a double layout)
class MyScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return MainShellLayout( // ❌ This is incorrect
      toolbar: MyToolbar(),
      content: MyContent(),
      primarySidebar: MySidebar(),
    );
  }
}
```

#### ✅ Correct Implementation
```dart
// Used as content within MainAppShell
class MyScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return Column( // ✅ This is correct
      children: [
        const MyToolbar(),
        const Expanded(child: MyContent()),
      ],
    );
  }
}
```

## Development Guidelines

### Package Exports

New widgets and providers should be properly exported:

```dart
// packages/features/my_feature/lib/my_feature.dart
export 'src/screens/my_screen.dart';
export 'src/widgets/my_sidebar.dart';
export 'src/providers/my_providers.dart';
```

### Adding AppActivityItemType

To add an activity bar item for a new screen, update the `AppActivityItemType` enum.

```dart
// packages/app/lib/src/activity_bar/app_activity_item_type.dart
enum AppActivityItemType {
  // Existing items...
  myNewScreen(12), // New index and type
}
```