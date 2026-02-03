# App Presentation Components

This package provides reusable UI components for the App application.
All components are optimized for desktop applications and integrated with a Figma-style design system and the new App color scheme system.

## Overview

App Presentation Components has the following characteristics:

- **Unified Design System**: Figma-style squircle shapes and hierarchical App color system
- **Color Scope System**: Context-aware color abstraction for each UI area
- **Riverpod Integration**: Uses Riverpod for state management and achieves reactive UI updates
- **Desktop Optimization**: Supports mouse operations, keyboard navigation, and responsive layouts
- **Accessibility Support**: Provides appropriate semantics, contrast ratios, and zoom control
- **Theme Color Support**: Dynamic theme color switching (blue, purple, etc.)

## Import

```dart
import 'package:presentation_components/presentation_components.dart';
```

## Using Color Scope System

Components are integrated with the color scope system, and appropriate colors are automatically applied for each UI area:

```dart
// Activity bar color scope
ColorScopeHelper.withActivityBarScope(
  child: AppButton(
    label: 'Home',
    leadingIcon: Icon(AppIcons.home),
    onPressed: () {},
  ),
)

// Sidebar color scope
ColorScopeHelper.withSideBarScope(
  child: AppListTile(
    leading: Icon(AppIcons.folder),
    title: Text('Folder'),
    isSelected: true,
  ),
)

// Dialog color scope
ColorScopeHelper.withDialogScope(
  child: SettingsSection(
    headerText: 'Settings',
    child: AppDropdownMenu<String>(
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'auto', label: 'Auto'),
        DropdownMenuEntry(value: 'manual', label: 'Manual'),
      ],
      hintText: 'Select mode',
    ),
  ),
)
```

## Theme Management and Color System

### Switching Theme Mode

```dart
class ThemeSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        AppButton(
          label: 'Light Mode',
          onPressed: () => ref.read(themeModeProvider.notifier).state = ThemeMode.light,
        ),
        AppButton(
          label: 'Dark Mode',
          onPressed: () => ref.read(themeModeProvider.notifier).state = ThemeMode.dark,
        ),
        AppButton(
          label: 'System Settings',
          onPressed: () => ref.read(themeModeProvider.notifier).state = ThemeMode.system,
        ),
      ],
    );
  }
}
```

### Changing Theme Color

```dart
// Change theme color to purple
ref.read(themeColorTypeProvider.notifier).setThemeColor(ThemeColorType.purple);

// Get current theme color
final colorScheme = ref.watch(appColorSchemeProvider);
final themeColor = colorScheme.theme.primaryColor;
```

## Component List

### Basic UI Components

#### AppText
**Overview**: Text widget that automatically applies typography styles based on app theme settings

**Key Properties**:
- `text`: Text to display
- `variant`: Typography variant (available variants: `uiHeading1`, `uiHeading2`, `uiHeading3`, `uiBody`, `uiCaption`, `codeBlock`, etc.)
- `color`: Text color (optional)
- `textAlign`: Text alignment
- `maxLines`: Maximum lines
- `overflow`: Overflow handling
- `disableZoom`: Disable accessibility zoom

**Usage Examples**:
```dart
// Main title
AppText(
  'Main Title',
  variant: AppTextVariant.uiHeading1,
)

// Subtitle
AppText(
  'Subtitle',
  variant: AppTextVariant.uiHeading2,
  color: Colors.grey,
)

// Body text
AppText(
  'Example of displaying long description text',
  variant: AppTextVariant.uiBody,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)

// Code block
AppText(
  'flutter run',
  variant: AppTextVariant.codeBlock,
)
```

#### AppTextField
**Overview**: Text field with Figma-style squircle shape. Applies different styles in focus state

**Key Properties**:
- `controller`: TextEditingController
- `focusNode`: FocusNode
- `decoration`: InputDecoration
- `backgroundColor`: Background color
- `borderColor`: Border color
- `activeBorderColor`: Border color when active
- `radius`: Corner radius
- `borderWidth`: Border width
- Supports all standard TextField properties

**Usage Example**:
```dart
AppTextField(
  controller: _controller,
  decoration: InputDecoration(
    hintText: 'Enter text...',
    prefixIcon: Icon(Icons.search),
  ),
  backgroundColor: Colors.grey[100],
  radius: 12.0,
)
```

#### AppTagsField
**Overview**: Tag input field for editing entity labels, etc. Uses textfield_tags package

**Key Properties**:
- `initialTags`: Initial tag list
- `onTagsChanged`: Callback when tags change
- `hintText`: Hint text
- `validator`: Validation function
- `textSeparators`: Text separators
- `maxTagLength`: Maximum tag length
- `minTagLength`: Minimum tag length
- `maxTags`: Maximum number of tags
- `tagBackgroundColor`: Tag background color
- `tagTextColor`: Tag text color
- `enabled`: Enabled/disabled state

**Usage Example**:
```dart
AppTagsField(
  initialTags: ['Flutter', 'Dart'],
  onTagsChanged: (tags) => print('Tags: $tags'),
  hintText: 'Enter tags and press Enter',
  maxTags: 10,
  validator: (tag) => tag.length < 2 ? 'Enter at least 2 characters' : null,
)
```

#### AppButton
**Overview**: Basic button component that automatically applies theme color and color scope. Figma-style squircle shape

**Key Properties**:
- `label`: Button label text
- `onPressed`: Callback when button is pressed
- `isPrimary`: Display as primary action button
- `leadingIcon`: Leading icon for button (optional)
- `trailingIcon`: Trailing icon for button (optional)
- `width`, `height`: Button size (optional)
- `enabled`: Enabled/disabled state
- `disableZoom`: Disable accessibility zoom
- `cornerRadius`, `cornerSmoothing`: Corner customization
- `backgroundColor`, `textColor`, `borderColor`: Color customization

**Usage Examples**:
```dart
// Basic button
AppButton(
  label: 'Cancel',
  onPressed: () {},
)

// Primary button
AppButton(
  label: 'Save',
  isPrimary: true,
  onPressed: () {},
)

// Button with icon
AppButton(
  label: 'Create New',
  leadingIcon: Icon(AppIcons.plus),
  isPrimary: true,
  onPressed: () {},
)

// Theme color change button
AppButton(
  label: 'Purple Theme',
  leadingIcon: Icon(AppIcons.palette),
  onPressed: () {
    ref.read(themeColorTypeProvider.notifier)
        .setThemeColor(ThemeColorType.purple);
  },
)

// Disabled state
AppButton(
  label: 'Disabled Button',
  enabled: false,
  onPressed: () {},
)
```

### Form and Input Components

#### FormItem
**Overview**: Form item component that displays setting name and value side by side (1 line)

**Key Properties**:
- `label`: Label text
- `child`: Setting component (Switch, DropdownButton, etc.)
- `labelWidth`: Width of label column (default: 200)
- `spacing`: Space between label and component (default: 16)
- `description`: Optional description text

**Usage Example**:
```dart
FormItem(
  label: 'Theme',
  description: 'Application appearance theme',
  child: AppDropdownMenu<String>(
    initialSelection: 'light',
    dropdownMenuEntries: [
      DropdownMenuEntry(value: 'light', label: 'Light'),
      DropdownMenuEntry(value: 'dark', label: 'Dark'),
    ],
    onSelected: (value) => print('Selected: $value'),
  ),
)
```

#### FormItemColumn
**Overview**: Form item component that displays setting name and value vertically (2 lines). Used in scenarios with limited width like sidebars

**Key Properties**:
- `label`: Label text
- `child`: Setting component (TextField, DropdownButton, etc.)
- `spacing`: Space between label and component (default: 8)
- `description`: Optional description text
- `disableZoom`: Whether to disable zoom functionality

**Usage Example**:
```dart
// Sidebar search form example
FormItemColumn(
  label: 'Keyword Search',
  description: 'Search nodes and links',
  child: AppTextField(
    hintText: 'Enter search keyword',
    onChanged: (value) => print('Search: $value'),
  ),
)

FormItemColumn(
  label: 'Filter',
  child: AppDropdownMenu<String>(
    initialSelection: 'all',
    dropdownMenuEntries: [
      DropdownMenuEntry(value: 'all', label: 'All'),
      DropdownMenuEntry(value: 'nodes', label: 'Nodes Only'),
      DropdownMenuEntry(value: 'links', label: 'Links Only'),
    ],
    onSelected: (value) => print('Filter: $value'),
  ),
)
```

#### FormList
**Overview**: Component that groups a list of form items or a single child element. Also integrates SettingsSection functionality. Can be made collapsible using AppExpansionTile

**Key Properties**:
- `title`: Section title
- `children`: List of form rows (for FormItem list)
- `child`: Single child element (for SettingsSection compatibility)
- `labelWidth`: Common label width for all rows (only used for children)
- `titleVariant`: Typography variant for title
- `rightWidget`: Widget to place at the right end of title
- `itemSpacing`: Space between form items
- `disableZoom`: Whether to disable zoom functionality
- `collapsible`: Whether to make collapsible
- `initiallyExpanded`: Initial expansion state (only valid if collapsible is true)
- `onExpansionChanged`: Callback when expansion state changes (only valid if collapsible is true)
- `expansionController`: ExpansionTileController (only valid if collapsible is true)

**Usage Examples**:
```dart
// Normal FormList
FormList(
  title: 'General Settings',
  children: [
    FormItem(
      label: 'Theme',
      child: AppDropdownMenu<String>(...),
    ),
    FormItem(
      label: 'Language',
      child: AppDropdownMenu<String>(...),
    ),
  ],
)

// Collapsible FormList
FormList(
  title: 'Advanced Settings',
  collapsible: true,
  initiallyExpanded: false,
  onExpansionChanged: (expanded) {
    print('Settings ${expanded ? 'expanded' : 'collapsed'}');
  },
  children: [
    FormItem(
      label: 'Debug Mode',
      child: Switch(value: false, onChanged: (value) {}),
    ),
    FormItem(
      label: 'Log Level',
      child: AppDropdownMenu<String>(...),
    ),
  ],
)
```

#### AppSegmentedButton
**Overview**: Segmented button that automatically applies app theme color. Supports multiple and single selection

**Key Properties**:
- `selected`: Currently selected set
- `segments`: List of button segment configurations
- `onSelectionChanged`: Callback when selection changes
- `showSelectedIcon`: Whether to show selected icon

**Usage Example**:
```dart
AppSegmentedButton<String>(
  selected: {'option1'},
  segments: [
    ButtonSegment(value: 'option1', label: Text('Option 1')),
    ButtonSegment(value: 'option2', label: Text('Option 2')),
    ButtonSegment(value: 'option3', label: Text('Option 3')),
  ],
  onSelectionChanged: (Set<String> selection) {
    print('Selected: $selection');
  },
  showSelectedIcon: true,
)
```

#### AppDropdownMenu
**Overview**: Dropdown menu using custom overlay menu. Design where menu completely covers button when selected

**Key Properties**:
- `initialSelection`: Initial selection value
- `onSelected`: Callback when selection changes
- `dropdownMenuEntries`: List of menu entries
- `width`: Menu width
- `height`: Menu height
- `textStyle`: Text style
- `hintText`: Hint text
- `enabled`: Enabled/disabled state
- `cornerRadius`: Corner radius
- `cornerSmoothing`: Corner smoothing
- Various color properties (background color, border color, etc.)

**Usage Example**:
```dart
AppDropdownMenu<String>(
  initialSelection: 'option1',
  dropdownMenuEntries: [
    DropdownMenuEntry(value: 'option1', label: 'Option 1'),
    DropdownMenuEntry(value: 'option2', label: 'Option 2'),
    DropdownMenuEntry(value: 'option3', label: 'Option 3'),
  ],
  onSelected: (String? value) {
    print('Selected: $value');
  },
  hintText: 'Please select',
  width: 200,
)
```

#### AppExpansionTile
**Overview**: Expandable tile with app standard style applied. Icon position and animation speed are customizable

**Key Properties**:
- `title`: Title widget
- `children`: Child widgets to display when expanded
- `backgroundColor`: Background color when expanded
- `collapsedBackgroundColor`: Background color when collapsed
- `shape`: Border when expanded
- `collapsedShape`: Border when collapsed
- `initiallyExpanded`: Initial expansion state
- `onExpansionChanged`: Callback when expansion state changes
- `childrenPadding`: Padding for child elements
- `tilePadding`: Padding for title
- `controller`: ExpansionTileController
- `animationDuration`: Animation duration
- `iconPosition`: Icon position (leading/trailing)

**Usage Example**:
```dart
AppExpansionTile(
  title: Text('Expandable Section'),
  iconPosition: ExpansionIconPosition.leading,
  animationDuration: Duration(milliseconds: 200),
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
    ListTile(title: Text('Item 3')),
  ],
  onExpansionChanged: (bool expanded) {
    print('Expanded: $expanded');
  },
)
```

### Layout and Container Components

#### AppContainer
**Overview**: Container widget with app-specific padding. Can place any widget on the left side

**Key Properties**:
- `child`: Child widget
- `leadingWidget`: Widget to display on the left
- `padding`: Custom padding
- `color`: Background color
- `decoration`: Decoration
- `width`: Container width
- `height`: Container height
- `alignment`: Child widget alignment
- `leadingWidth`: Width of left widget

**Usage Example**:
```dart
AppContainer(
  leadingWidget: Icon(Icons.drag_indicator),
  child: Text('Content'),
  padding: EdgeInsets.all(16),
  color: Colors.grey[100],
)
```

#### AppDivider / AppVerticalDivider
**Overview**: Provides unified Divider style throughout the app. Automatically applies theme color

**Key Properties**:
- `height`: Height above and below divider line (AppDivider)
- `width`: Width left and right of divider line (AppVerticalDivider)
- `thickness`: Thickness of divider line
- `indent`: Start indent of divider line
- `endIndent`: End indent of divider line
- `color`: Color of divider line (optional)

**Usage Examples**:
```dart
// Horizontal divider
AppDivider(
  thickness: 1.0,
  indent: 16.0,
  endIndent: 16.0,
)

// Vertical divider
AppVerticalDivider(
  thickness: 1.0,
  indent: 8.0,
  endIndent: 8.0,
)
```

#### AppDialog
**Overview**: Provides unified Dialog style throughout the app. Applies Figma-style rounded corners and theme color

**Key Properties**:
- `child`: Child widget
- `width`: Dialog width
- `height`: Dialog height
- `maxWidth`: Dialog maximum width
- `maxHeight`: Dialog maximum height
- `minWidth`: Dialog minimum width
- `minHeight`: Dialog minimum height
- `padding`: Dialog inner padding
- `elevation`: Dialog shadow height
- `cornerRadius`: Dialog corner radius
- `cornerSmoothing`: Dialog corner smoothing
- `backgroundColor`: Dialog background color

**Usage Example**:
```dart
// Display dialog
showAppDialog(
  context: context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Dialog Title'),
      SizedBox(height: 16),
      Text('Dialog Content'),
      SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    ],
  ),
  width: 400,
  padding: EdgeInsets.all(24),
)
```

### Navigation and Layout Components

#### ActivityBar
**Overview**: Activity bar divided into 2 sections (top: main features, bottom: meta features)

**Key Properties**:
- `topItems`: List of items in top section
- `bottomItems`: List of items in bottom section
- `selectedIndex`: Index of selected item

**ActivityBarItem**:
- `icon`: Icon
- `label`: Label
- `logicalIndex`: Logical index
- `badge`: Badge text (optional)
- `onTap`: Callback when tapped

**Usage Example**:
```dart
ActivityBar(
  topItems: [
    ActivityBarItem(
      icon: Icons.home,
      label: 'Home',
      logicalIndex: 0,
      onTap: () => print('Home'),
    ),
    ActivityBarItem(
      icon: Icons.search,
      label: 'Search',
      logicalIndex: 1,
      badge: '3',
      onTap: () => print('Search'),
    ),
  ],
  bottomItems: [
    ActivityBarItem(
      icon: Icons.settings,
      label: 'Settings',
      logicalIndex: 2,
      onTap: () => print('Settings'),
    ),
  ],
  selectedIndex: 0,
)
```

#### MasterDetailLayout
**Overview**: Layout that implements master-detail pattern. Responsive with Riverpod integration

**Key Properties**:
- `items`: List of item IDs
- `masterItemBuilder`: Builder function for master items
- `detailBuilder`: Builder function for detail view
- `initialMasterWidth`: Initial width of master view in desktop mode
- `minMasterWidth`: Minimum width of master view when resizing
- `maxMasterWidth`: Maximum width of master view when resizing
- `breakpoint`: Breakpoint width for responsive layout
- `showDetailOnInit`: Initial detail display in mobile mode
- `initialSelectedId`: Initial selected item ID
- Various color properties

**Usage Example**:
```dart
MasterDetailLayout(
  items: ['item1', 'item2', 'item3'],
  masterItemBuilder: (context, itemId, isSelected, onSelect) {
    return ListTile(
      title: Text('Item $itemId'),
      selected: isSelected,
      onTap: onSelect,
    );
  },
  detailBuilder: (context, selectedId, onBack) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Detail for $selectedId'),
          ElevatedButton(
            onPressed: onBack,
            child: Text('Back'),
          ),
        ],
      ),
    );
  },
  initialMasterWidth: 300,
  breakpoint: 600,
)
```

#### MainShellLayout
**Overview**: Main shell layout for application. Arranges toolbar, activity bar, sidebar, and main content

**Key Properties**:
- `toolbar`: Toolbar widget
- `content`: Main content widget
- `activityBar`: Activity bar widget (optional)
- `primarySidebar`: Primary sidebar widget (optional)
- `secondarySidebar`: Secondary sidebar widget (optional)
- `showActivityBar`: Activity bar visibility control
- `showPrimarySidebar`: Primary sidebar visibility control
- `showSecondarySidebar`: Secondary sidebar visibility control

**Usage Example**:
```dart
MainShellLayout(
  toolbar: AppToolbar(),
  activityBar: AppActivityBar(),
  primarySidebar: PrimarySidebar(),
  content: MainContent(),
  secondarySidebar: SecondarySidebar(),
  showActivityBar: true,
  showPrimarySidebar: true,
  showSecondarySidebar: false,
)
```

### Data Display and List Components

#### TableView
**Overview**: Displays data in table format and provides features like sorting, filtering, and editing

**Key Properties**:
- `title`: Table title
- `columns`: Table column definitions
- `data`: Table data
- `keyExtractor`: Function to extract primary key from data
- `onRowsSelected`: Callback when rows are selected
- `onRowDoubleTap`: Callback when row is double-clicked
- `allowMultiSelect`: Whether to allow multiple selection
- `allowInlineEdit`: Whether to allow inline editing of rows
- `maxHeight`: Maximum height of table
- `initialSortStates`: Initial sort state
- `compare`: Data comparison function for columns

**Usage Example**:
```dart
TableView<Person>(
  title: 'Personnel List',
  columns: [
    TableColumn(
      key: 'name',
      title: 'Name',
      builder: (person) => Text(person.name),
    ),
    TableColumn(
      key: 'age',
      title: 'Age',
      builder: (person) => Text('${person.age}'),
    ),
  ],
  data: people,
  keyExtractor: (person) => person.id,
  onRowsSelected: (selectedPeople) {
    print('Selected: ${selectedPeople.length} people');
  },
  allowMultiSelect: true,
)
```

#### TabView
**Overview**: General-purpose tab view component for building tabbed interfaces

**Key Properties**:
- `tabs`: List of tab items
- `initialSelectedTabId`: ID of initially selected tab
- `onTabSelected`: Callback when tab is selected
- `highlightStyle`: Highlight style
- `tabBarBackgroundColor`: Tab bar background color
- `selectedTabColor`: Color of selected tab
- `unselectedTabColor`: Color of unselected tab

**TabItem**:
- Icon only: `TabItem.iconOnly()`
- Text only: `TabItem.textOnly()`
- Icon and text: `TabItem.withIconAndText()`

**Usage Example**:
```dart
TabView(
  tabs: [
    TabItem.iconOnly(
      id: 'info',
      icon: Icons.info,
      content: InfoContentView(),
      tooltip: 'Information',
    ),
    TabItem.textOnly(
      id: 'filter',
      text: 'Filter',
      content: FilterContentView(),
    ),
    TabItem.withIconAndText(
      id: 'settings',
      icon: Icons.settings,
      text: 'Settings',
      content: SettingsContentView(),
    ),
  ],
  highlightStyle: TabHighlightStyle.underline,
)
```

#### AppListTile
**Overview**: List tile that handles selection state and applies appropriate theme color

**Key Properties**:
- `title`: Title widget
- `subtitle`: Subtitle widget (optional)
- `leading`: Leading widget (optional)
- `trailing`: Trailing widget (optional)
- `isSelected`: Selection state
- `onTap`: Callback when tapped
- `onLongPress`: Callback when long pressed
- `dense`: Dense display
- `contentPadding`: Content padding

**Usage Example**:
```dart
AppListTile(
  leading: Icon(Icons.person),
  title: Text('Username'),
  subtitle: Text('user@example.com'),
  trailing: Icon(Icons.arrow_forward_ios),
  isSelected: true,
  onTap: () => print('Tapped'),
)
```

### Other Components

#### SearchField
**Overview**: Platform-adaptive search field with suggestion functionality

**Key Properties**:
- `suggestions`: List of suggestions to display
- `onSuggestionTap`: Callback when suggestion is tapped
- `onSubmit`: Callback when search field is submitted
- `hint`: Hint text to display when empty
- `enabled`: Whether search field is enabled
- `value`: Current value of search field
- `onSaved`: Callback when text changes
- `onClear`: Callback when clear button is tapped

**Usage Example**:
```dart
SearchField(
  suggestions: ['Flutter', 'Dart', 'Widget'],
  onSuggestionTap: (suggestion) => print('Selected: $suggestion'),
  onSubmit: (query) => print('Search: $query'),
  hint: 'Search...',
  value: searchQuery,
  onClear: () => setState(() => searchQuery = ''),
)
```

#### ButtonGroup
**Overview**: Logically groups and displays related action buttons

**Key Properties**:
- `children`: List of buttons to display in group
- `spacing`: Space between buttons
- `backgroundColor`: Background color of entire group
- `padding`: Group padding
- `direction`: Button display direction (horizontal/vertical)

**Usage Example**:
```dart
ButtonGroup(
  children: [
    IconButton(icon: Icon(Icons.copy), onPressed: () {}),
    IconButton(icon: Icon(Icons.paste), onPressed: () {}),
    IconButton(icon: Icon(Icons.delete), onPressed: () {}),
  ],
  spacing: 8.0,
  direction: Axis.horizontal,
)
```

#### IconLabelButton
**Overview**: Button that displays icon and label. Can optionally place trailing widget

**Key Properties**:
- `icon`: Icon to display
- `label`: Label to display
- `trailing`: Widget to display after label (optional)
- `onPressed`: Callback when button is pressed
- `isSelected`: Whether button is currently selected
- `horizontalPadding`: Horizontal padding of button content
- `verticalPadding`: Vertical padding of button content
- `iconSpacing`: Space between icon and label
- Various color properties

**Usage Example**:
```dart
IconLabelButton(
  icon: Icon(Icons.folder),
  label: 'Folder',
  trailing: Icon(Icons.arrow_drop_down),
  isSelected: true,
  onPressed: () => print('Folder button pressed'),
)
```

#### Section
**Overview**: Section container with title and description. Automatically inserts dividers between child elements

**Key Properties**:
- `children`: Child widgets in section
- `title`: Section title (optional)
- `description`: Section description (optional)
- `padding`: Section padding
- `spacing`: Space between child elements
- `showDividers`: Whether to show dividers
- `backgroundColor`: Section background color

**Usage Example**:
```dart
Section(
  title: Text('Settings Section'),
  description: Text('Application settings items'),
  children: [
    ListTile(title: Text('Setting Item 1')),
    ListTile(title: Text('Setting Item 2')),
    ListTile(title: Text('Setting Item 3')),
  ],
  showDividers: true,
  spacing: 8.0,
)
```

#### OverflowMenu
**Overview**: Menu that stores features that cannot be displayed due to screen size

**Key Properties**:
- `items`: List of items to display in menu
- `icon`: Menu icon
- `iconColor`: Icon color
- `iconSize`: Icon size
- `tooltip`: Menu description (tooltip)

**Usage Example**:
```dart
OverflowMenu(
  items: [
    OverflowMenuItem(
      title: 'Export',
      icon: Icons.download,
      onTap: () => print('Export'),
    ),
    OverflowMenuItem(
      title: 'Print',
      icon: Icons.print,
      onTap: () => print('Print'),
    ),
  ],
  tooltip: 'More options',
)
```

## Usage

### Basic Import

```dart
import 'package:presentation_components/presentation_components.dart';
```

### Theme System Integration

Components are integrated with the App theme system and automatically retrieve theme colors through Riverpod capsules:

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme colors are automatically applied
    return AppContainer(
      child: AppText(
        'Hello World',
        variant: AppTextVariant.uiHeading1,
      ),
    );
  }
}
```

### State Management Integration

Many components are integrated with Riverpod capsules, making state management easy:

```dart
class TabExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabState = ref.watch(tabViewStateProvider);

    return TabView(
      tabs: myTabs,
      initialSelectedTabId: tabState.selectedTabId,
      onTabSelected: tabState.selectTab,
    );
  }
}
```

## Development Guidelines

### Adding New Components

1. Create appropriate directory under `lib/src/`
2. Implement component class (recommended to inherit from ConsumerWidget)
3. Add export to `lib/presentation_components.dart`
4. Add description to this README

### Theme Support

- Use capsules from `core_themes` package to retrieve theme colors
- Utilize `effectiveAppColorsProvider` and `effectiveAppColorSchemeProvider`
- Avoid using hardcoded colors

### Accessibility

- Provide appropriate semantic labels
- Ensure sufficient contrast ratio
- Support keyboard navigation

## Dependencies

- `flutter`: Flutter SDK
- `flutter_riverpod`: Riverpod state management
- `core_themes`: App theme system
- `figma_squircle`: Figma-style squircle shape
- `textfield_tags`: Tag input field
- `searchfield`: Search field
