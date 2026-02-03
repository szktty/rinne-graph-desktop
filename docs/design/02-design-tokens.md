# 02. Design Tokens

## 🌈 Color System

### 🌓 Light Mode / Dark Mode Support

RinneGraph supports **automatic dark mode switching** and is uniformly managed by `AppColorScheme`.

**Features:**
- Automatic reflection of system settings
- Manual switching support
- Smooth transitions
- Over 60 detailed color definitions

### 🎨 Color Palette

> **Important**: These colors are defined in `AppColorScheme`. Please use semantic property names instead of fixed values. Light/dark mode switching is handled automatically.

```dart
// ✅ Recommended
final appColorScheme = ref.watch(effectiveColorSchemeProvider);
final bgColor = appColorScheme.appSpecific.graph.background;

// ❌ Avoid
final bgColor = Colors.blue; // Hardcoding
```

### 🚫 Restriction on Alpha Value Usage

**From the perspective of accessibility and design consistency, the use of alpha values is restricted:**

#### Prohibitions
- Setting alpha values with `withAlpha()`, `withOpacity()`, `Color.fromARGB()`
- Using colors with alpha values other than `Colors.transparent`
- Implementing contrast ratios dependent on background color

#### Reasons
- **Accessibility**: Potential failure to meet WCAG contrast ratio standards
- **Visual Impairment Support**: Difficulty in recognition for low-vision users
- **Consistency**: Issues with appearance changing based on background
- **Maintainability**: Difficulty in predicting impact during design changes

#### Alternatives
```dart
// ❌ Using alpha
Container(color: Colors.blue.withOpacity(0.3))

// ✅ Defining dedicated colors
Container(color: colorScheme.interactive.button.backgroundDisabled)
```

#### Background Color

| Level | Purpose | Color Token | Integrated Targets |
|---|---|---|---|
| **Level 1: Main Background** | Basic content area | `base.background` | Base, panel, dialog, graph view |
| **Level 2: Navigation Background** | Sidebar area | `uiAreas.sideBar.background` | Primary sidebar, secondary sidebar, activity bar |
| **Level 3: System Background** | Window control area | `uiAreas.titleBar.background` | Title bar, status bar |

##### Optimized Color Values through Integration
| Level | Dark Mode | Light Mode |
|---|---|---|
| **Level 1** | `#1C1C1E` | `#FFFFFF` |
| **Level 2** | `#2C2C2E` | `#F2F2F7` |
| **Level 3** | `#2D2D30` | `#F3F3F3` |

#### Text Color (Text)

| Purpose | Color Token | Example Usage |
|---|---|---|
| Standard text color | `base.foreground` | `AppColorScheme.base.foreground` |
| Auxiliary text color | `base.foreground.withAlpha(179)` | `AppColorScheme.base.foreground.withAlpha(179)` |
| Disabled text color | `base.foreground.withAlpha(128)` | `AppColorScheme.base.foreground.withAlpha(128)` |
| Accent text (e.g., links) | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` |

#### Border Color (Border)

| Purpose | Color Token | Example Usage |
|---|---|---|
| Standard border | `base.border` | `AppColorScheme.base.border` |
| Button outline | `interactive.button.border.normal` | `AppColorScheme.interactive.button.border.normal` |
| Input field outline | `interactive.input.border` | `AppColorScheme.interactive.input.border` |
| Focused outline | `interactive.input.focusBorder` | `AppColorScheme.interactive.input.focusBorder` |
| Title bar boundary | `uiAreas.titleBar.border` | `AppColorScheme.uiAreas.titleBar.border` |
| Separator line | `base.divider` | `AppColorScheme.base.divider` |

#### Interaction Colors (Interactive)

| Purpose | Color Token | Example Usage |
|---|---|---|
| Normal button background | `interactive.button.background.normal` | `AppColorScheme.interactive.button.background.normal` |
| Normal button hover background | `interactive.button.background.hover` | `AppColorScheme.interactive.button.background.hover` |
| Normal button active background | `interactive.button.background.active` | `AppColorScheme.interactive.button.background.active` |
| Primary button background | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` |
| Primary button text | `interactive.button.primaryForeground` | `AppColorScheme.interactive.button.primaryForeground` |
| Destructive operation button background | `interactive.button.destructiveBackground` | `AppColorScheme.interactive.button.destructiveBackground` |
| Destructive operation button text | `interactive.button.destructiveForeground` | `AppColorScheme.interactive.button.destructiveForeground` |
| Selection background | `base.selection` | `AppColorScheme.base.selection` |
| Hover background | `interactive.list.hoverBackground` | `AppColorScheme.interactive.list.hoverBackground` |
| Quick input field background | `interactive.quickInput.fieldBackground` | `AppColorScheme.interactive.quickInput.fieldBackground` |
| Quick input selected item background | `interactive.quickInput.selectedItemBackground` | `AppColorScheme.interactive.quickInput.selectedItemBackground` |
| Overlay action button background | `interactive.actionButton.background` | `AppColorScheme.interactive.actionButton.background` |
| Overlay action button icon | `interactive.actionButton.iconColor` | `AppColorScheme.interactive.actionButton.iconColor` |

#### Graph-Specific Colors (Graph)

| Purpose | Color Token | Example Usage |
|---|---|---|
| Primary graph node | `appSpecific.graph.nodeBase` | `AppColorScheme.appSpecific.graph.nodeBase` |
| Node inner text | `appSpecific.graph.nodeText` | `AppColorScheme.appSpecific.graph.nodeText` |
| Primary connection line | `appSpecific.graph.linkBase` | `AppColorScheme.appSpecific.graph.linkBase` |
| Selection highlight | `appSpecific.graph.selectionHighlight` | `AppColorScheme.appSpecific.graph.selectionHighlight` |

#### Table-Specific Colors (Table)

| Purpose | Color Token | Example Usage |
|---|---|---|
| Table background | `appSpecific.table.background` | `AppColorScheme.appSpecific.table.background` |
| Header background | `appSpecific.table.headerBackground` | `AppColorScheme.appSpecific.table.headerBackground` |
| Header text | `appSpecific.table.headerText` | `AppColorScheme.appSpecific.table.headerText` |
| Odd row background | `appSpecific.table.oddRowBackground` | `AppColorScheme.appSpecific.table.oddRowBackground` |
| Even row background | `appSpecific.table.evenRowBackground` | `AppColorScheme.appSpecific.table.evenRowBackground` |
| Cell text | `appSpecific.table.cellText` | `AppColorScheme.appSpecific.table.cellText` |
| Selected row background | `appSpecific.table.selectedRowBackground` | `AppColorScheme.appSpecific.table.selectedRowBackground` |
| Selected row text | `appSpecific.table.selectedRowText` | `AppColorScheme.appSpecific.table.selectedRowText` |
| Hover row background | `appSpecific.table.hoverRowBackground` | `AppColorScheme.appSpecific.table.hoverRowBackground` |
| Active row background | `appSpecific.table.activeRowBackground` | `AppColorScheme.appSpecific.table.activeRowBackground` |
| Normal border | `appSpecific.table.border` | `AppColorScheme.appSpecific.table.border` |
| Active border | `appSpecific.table.activeBorder` | `AppColorScheme.appSpecific.table.activeBorder` |

> **Usage**: Used in table view components. Avoids transparency and provides clear color distinctions considering accessibility.

#### Quick Input Specific Colors (Quick Input)

| Purpose | Color Token | Example Usage |
|---|---|---|
| Input field background | `interactive.quickInput.fieldBackground` | `AppColorScheme.interactive.quickInput.fieldBackground` |
| Input field border | `interactive.quickInput.fieldBorder` | `AppColorScheme.interactive.quickInput.fieldBorder` |
| Active border | `interactive.quickInput.fieldActiveBorder` | `AppColorScheme.interactive.quickInput.fieldActiveBorder` |
| Placeholder text | `interactive.quickInput.placeholderText` | `AppColorScheme.interactive.quickInput.placeholderText` |
| Input text | `interactive.quickInput.inputText` | `AppColorScheme.interactive.quickInput.inputText` |
| Icon color | `interactive.quickInput.iconColor` | `AppColorScheme.interactive.quickInput.iconColor` |
| Dropdown background | `interactive.quickInput.dropdownBackground` | `AppColorScheme.interactive.quickInput.dropdownBackground` |
| Dropdown border | `interactive.quickInput.dropdownBorder` | `AppColorScheme.interactive.quickInput.dropdownBorder` |
| Selected item background | `interactive.quickInput.selectedItemBackground` | `AppColorScheme.interactive.quickInput.selectedItemBackground` |
| Selected item text | `interactive.quickInput.selectedItemText` | `AppColorScheme.interactive.quickInput.selectedItemText` |
| Hover background | `interactive.quickInput.hoverBackground` | `AppColorScheme.interactive.quickInput.hoverBackground` |
| Item text | `interactive.quickInput.itemText` | `AppColorScheme.interactive.quickInput.itemText` |
| Item description text | `interactive.quickInput.itemDescriptionText` | `AppColorScheme.interactive.quickInput.itemDescriptionText` |

> **Usage**: Used in quick input components such as pathfinders, command palettes, and search fields.

#### Status Display Colors (Status)

| Purpose | Color Token | Example Usage |
|---|---|---|
| Info display | `status.info` | `AppColorScheme.status.info` |
| Success display | `status.success` | `AppColorScheme.status.success` |
| Warning display | `status.warning` | `AppColorScheme.status.warning` |
| Error display | `status.error` | `AppColorScheme.status.error` |

### 🎭 Alpha Value Usage Patterns

Alpha values are systematically used to express **UI hierarchy and state**:

| Purpose | Decimal Value | Alpha Value | Example Use |
|---|---|---|---|
| **Subtle** | 0.05 | 13 | Minor highlights, subtle separators |
| **Light** | 0.1 | 26 | Hover effects, light backgrounds |
| **Medium** | 0.15 | 38 | Segmented button selected state |
| **Strong** | 0.2 | 51 | Active state, tag backgrounds |
| **Emphasis** | 0.3 | 77 | Emphasis, important selected states |

**Example Usage:**
```dart
// Semantic usage
Color.withAlpha(26) // Hover effect
Color.withAlpha(51) // Active state
```

## 🎨 Theme Color System

### 🌈 Concept of Theme Colors

RinneGraph adopts a system similar to **macOS accent colors and Windows theme colors**, allowing users to select the primary color for the entire application according to their preference.

**Features:**
- Provides **8 default theme colors**
- Used for **primary action buttons** and **selection states**
- Color values optimized for both **light and dark modes**
- Emphasizes **consistency with system settings**

### 🎯 Available Theme Colors

| Theme Color | Color Token | Example Usage | Description |
|---|---|---|---|
| **Blue** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Standard blue (default) |
| **Purple** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Purple |
| **Pink** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Pink |
| **Red** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Red |
| **Orange** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Orange |
| **Yellow** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Yellow |
| **Green** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Green |
| **Gray** | `theme.primaryColor` | `AppColorScheme.theme.primaryColor` | Gray (equivalent to graphite) |

> **Note**: Theme colors are selected by `ThemeColorType` enum, and appropriate colors are automatically applied for light/dark modes.

### 🔧 Application of Theme Colors

**Primary Actions:**
- Background color of `AppButton.primary()`
- Important action buttons
- CTA buttons
- Focus state border color

**Selection States:**
- Checkbox selection color
- List item selection highlight
- Tab selection state

**Graph View:**
- Base color of graph nodes
- Selection highlight color
- Emphasis color for important elements

### 🎭 Theme Color Variations

Each theme color automatically generates the following variations:

```dart
// Base color
primaryColor: Base color of the theme

// Interaction colors
hoverColor: Hover color (lighter/darker than base color)
pressedColor: Pressed color (darker/lighter than base color)
selectionColor: Selection background color (lighter version of base color)
```

### 🔄 Changing Theme Colors

```dart
// ✅ Recommended: Getting color scheme via provider
final appColorScheme = ref.watch(effectiveColorSchemeProvider);
final primaryColor = appColorScheme.theme.primaryColor;

// ✅ Recommended: Changing theme color
ref.read(themeColorTypeProvider.notifier).state = ThemeColorType.green;

// ✅ Recommended: Concrete example
Container(
  color:appColorScheme.uiAreas.activityBar.background,
  child: Icon(
    Icons.home,
    color:appColorScheme.uiAreas.activityBar.activeItem,
  ),
)
```

### 💡 Usage Guidelines

**✅ Recommended Usage:**
- Background color of `AppButton.primary()`
- Primary actions (Save, Execute, Confirm buttons)
- Display of selection states
- Highlighting important information
- Expression of brand identity

**❌ Avoid:**
- Displaying errors or warnings (use `AppColorScheme.status.error`)
- Destructive operations (use `AppButton.destructive()`)
- Decorative color usage
- Large area background colors
- Base text colors

## 🏗️ Title Bar Specification

### 📐 Basic Specification

The title bar is a cross-platform title bar displayed at the top of the application window.

**Platform Support:**
- **macOS**: Integration with native title bar
- **Windows**: Implemented as a custom title bar
- **Linux**: Supports platform-specific adjustments

| Item | Value | Description |
|---|---|---|
| **Height** | 50px | Total height including 1px border |
| **Border** | 1px | Bottom border |
| **Layout** | Horizontal Row | Element arrangement from left to right |
| **Internal Padding** | 10px top/bottom | Content area height 48px (50px - 2px border) |

### 🎨 Color Specification

**✅ Recommended Implementation:**
- `AppColorScheme.uiAreas.titleBar.background` - Title bar background color
- `AppColorScheme.uiAreas.titleBar.border` - Title bar border color
- `AppColorScheme.uiAreas.titleBar.iconColor` - Title bar icon color

### 🏗️ Layout Structure

The title bar consists of the following areas:

1. **Left area** (90px left padding): Sidebar toggle button
2. **Center area** (Expanded): Pathfinder field
3. **Right area**: Graph title bar, detail panel toggle

### 📏 Relationship with Sidebar

**Behavior based on display state:**
- **Sidebar visible**: Primary sidebar title bar and main area title bar displayed in parallel
- **Sidebar hidden**: Only main area title bar displayed
- **Important**: In both states, the position of the leftmost element is unified at the right of the traffic light buttons (90px position)

### 🎯 Positioning Relative to macOS Traffic Light Buttons

**Traffic Light Button Specification:**
- **Occupied width**: 90px (from left edge)
- **Recommended margin**: 8px
- **Safe area**: 98px (90px + 8px)

**Placement Rules (Unified Principle):**
- **All title bars**: Elements are placed from the right of the traffic light buttons (90px position)
- **Maintain consistency**: Regardless of sidebar visibility, the position of the leftmost element remains the same

### 🔧 UI Element Detail Specification

#### Internal Padding Specification
| Item | Value | Description |
|---|---|---|
| **Top/Bottom Padding** | 10px | Vertical centering of elements within the title bar |
| **Content Height** | 30px | Recommended height for buttons and fields |
| **Vertical Alignment** | Center | Vertically center all elements |
| **Minimum Tap Area** | 44px | Accessibility standard (WCAG 2.1 AA) |

**Design Rationale:**
- **50px total height** - 1px border = **49px usable height**
- **30px content** + **10px top/bottom padding** = **50px**
- **44px minimum tap area** ensured by padding around buttons

#### Sidebar Toggle Button
| Item | Value | Description |
|---|---|---|
| **Icon Size** | 20px | AppIcons.panelLeft/panelLeftClose |
| **Button Size** | 30x30px | minWidth/minHeight constraints |
| **Splash Radius** | 20px | Ripple effect on tap |
| **Padding** | 0px | Internal button padding |
| **Left Margin** | 90px (traffic light button width) | Unified across all title bars |

#### Pathfinder Field
| Item | Value | Description |
|---|---|---|
| **Layout** | Expanded | Occupies available center space |
| **Height** | 30px | Centered with 10px internal title bar padding |
| **Hint Text** | "Search path... (Ctrl+P)" | Normal state |
| **Disabled Text** | "Select a stack" | When no stack is selected |
| **Left/Right Margins** | 4px (left) / 16px (right) | Spacing with adjacent elements |
| **Internal Padding** | 12px horizontal, 6px vertical | Padding for text input area |

#### Detail Panel Toggle Button
| Item | Value | Description |
|---|---|---|
| **Display Condition** | Only for Graph Navigation (index 0), Table View (index 10) | Screen-specific display |
| **Icon Size** | 20px | AppIcons.panelRight/panelRightClose |
| **Button Size** | 30x30px | Same specification as sidebar toggle button |
| **Right Margin** | 16px | Distance from right edge |

### 🔄 Behavior when both sidebars are hidden

**Layout Change:**
- Primary sidebar title bar becomes hidden
- Main area title bar is displayed full width
- Leftmost element position maintained at the right of the traffic light buttons (90px position)

**Displayed Elements:**
- Sidebar toggle button (functions as an open button)
- Pathfinder field (center area)
- Detail panel toggle button (only for applicable screens)

## 🔍 Quick Input Specification

### 📐 Basic Specification

Quick input is a component that provides fast input and search functions such as pathfinders, command palettes, and search fields.

| Item | Value | Description |
|---|---|---|
| **Input field height** | 32px | Standard input field height |
| **Dropdown max height** | 400px | Max height for search results display area |
| **Item height** | 40px | Standard height for search result items |
| **Border width** | 1px | Border width for fields and dropdowns |

### 🎨 Color Specification

```dart
// ✅ Recommended: Using dedicated quick input properties
final appColorScheme = ref.watch(effectiveColorSchemeProvider);

AppTextField(
  backgroundColor:appColorScheme.interactive.quickInput.fieldBackground,
  borderColor:appColorScheme.interactive.quickInput.fieldBorder,
  activeBorderColor:appColorScheme.interactive.quickInput.fieldActiveBorder,
  hintText: 'パスを検索...',
  style: TextStyle(
    color:appColorScheme.interactive.quickInput.inputText,
  ),
  prefixIcon: Icon(
    AppIcons.search,
    color:appColorScheme.interactive.quickInput.iconColor,
  ),
)

// ❌ Avoid: Transparency or direct colorScheme usage
AppTextField(
  backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(128), // Transparency discouraged
  borderColor: colorScheme.outline, // Direct reference discouraged
)
```

### 🏗️ Component Structure

Quick input consists of the following elements:

1. **Input field**: For entering search queries
2. **Prefix icon**: Such as a search icon
3. **Dropdown**: Displays search results and suggestions
4. **Item list**: A list of selectable items
5. **Selection highlight**: Supports keyboard navigation

### 💡 Best Practices for Implementation

**✅ Recommended Implementation:**
- Use semantic color properties
- Support keyboard navigation (arrow keys, Enter, Escape)
- Proper focus management
- Accessibility support (screen readers, etc.)

**❌ Avoid:**
- Using transparency (`withAlpha()`)
- Hardcoded color values
- Direct Flutter ColorScheme usage
- Lack of keyboard navigation support

### 🔧 Customization Example

```dart
// Customize quick input colors
final customColorScheme = appColorScheme.copyWith(
  interactive:appColorScheme.interactive.copyWith(
    quickInput:appColorScheme.interactive.quickInput.copyWith(
      fieldBackground: customFieldBackground,
      selectedItemBackground: customSelectionColor,
      hoverBackground: customHoverColor,
    ),
  ),
);
```

## 📏 Spacing and Margins

### 📊 Spacing Scale

The following scale is **consistently used across all components**:

| Token Name | Value | Purpose | Example Usage |
|---|---|---|---|
| **xs** | 4px | Icon spacing | `AppSpacing.xs`, `AppPadding.xs` |
| **sm** | 8px | Inner element padding | `AppSpacing.sm`, `AppPadding.sm` |
| **md** | 12px | Component inner margin | `AppSpacing.md`, `AppPadding.md` |
| **lg** | 16px | Section inner margin | `AppSpacing.lg`, `AppPadding.lg` |
| **xl** | 20px | Special purposes | `AppSpacing.xl`, `AppPadding.xl` |
| **xxl** | 24px | Section spacing | `AppSpacing.xxl`, `AppPadding.xxl` |
| **xxxl** | 32px | Large section spacing | `AppSpacing.xxxl`, `AppPadding.xxxl` |

### 🎯 Spacing Tokens

**AppSpacing & AppPadding** provide **predefined tokens** compliant with the 4px grid system:

#### AppSpacing
- **Role**: Provides predefined spacing values
- **Function**: Consistent spacing compliant with the 4px grid
- **Feature**: Performance optimized with `const` support
- **Zoom support**: Use Responsive version if necessary

```dart
// ✅ Recommended: Using predefined tokens
Column(
  children: [
    Text('Title'),
    AppSpacing.verticalLg,        // 16px
    Container(child: content),
    AppSpacing.verticalXxl,       // 24px
    Text('Next Section'),
  ],
)

// ✅ Directional spacing
Row(
  children: [
    Icon(Icons.star),
    AppSpacing.horizontalSm,      // 8px
    Text('Label'),
  ],
)
```

#### AppPadding
- **Role**: Provides predefined padding values
- **Function**: Consistent EdgeInsets values
- **Feature**: Flexible and combinable

```dart
// ✅ Recommended: Using predefined tokens
Container(
  padding: AppPadding.md,           // 12px all directions
  child: Text('Content'),
)

// ✅ Directional padding
Container(
  padding: AppPadding.horizontalLg, // 16px left/right only
  child: widget,
)

// ✅ Combined specification
Container(
  padding: EdgeInsets.only(
    left: AppPadding.lg.left,       // 16px
    right: AppPadding.lg.right,     // 16px
    top: AppPadding.sm.top,         // 8px
    bottom: AppPadding.xl.bottom,   // 20px
  ),
  child: widget,
)
```

## ✍️ Typography

### 📝 Font Hierarchy

RinneGraph adopts a typography system **optimized for specific uses**:

#### Fonts for UI Elements

| Variant | TextTheme | Font Size | Example Use |
|---|---|---|---|
| `uiHeading1` | `headlineLarge` | 32px | Page title, main header |
| `uiHeading2` | `headlineMedium` | 28px | Section title |
| `uiHeading3` | `headlineSmall` | 24px | Subsection title |
| `uiBody` | `bodyMedium` | 16px | Button text, general UI |
| `uiCaption` | `bodySmall` | 14px | Auxiliary information, descriptive text |
| `uiSmall` | `labelSmall` | 11px | Small labels, badges |

#### Fonts for Content

| Variant | TextTheme | Font Size | Example Use |
|---|---|---|---|
| `textHeading1` | `displayLarge` | 57px | Document title |
| `textHeading2` | `displayMedium` | 45px | Chapter title |
| `textHeading3` | `displaySmall` | 36px | Section title |
| `textBody` | `bodyLarge` | 18px | Body text |
| `textCaption` | `bodyMedium` | 16px | Caption |
| `textSmall` | `bodySmall` | 14px | Supplementary text |

#### Fonts for Entities/Graphs

| Purpose | Variant | TextTheme | Description |
|---|---|---|---|
| **Entity** | `entityLabelPrimary` | `labelLarge` | Graph node labels |
| | `entityLabelSecondary` | `labelMedium` | Edge labels |
| | `entityLabelMeta` | `labelSmall` | Metadata labels |

### 🔤 Implementation Method

```dart
// ✅ Recommended: Using AppText component
AppText(
  'Button Label',
  variant: AppTextVariant.uiBody,
)

// ✅ Recommended: Direct style specification
Text(
  'Title',
  style: context.appTextTheme.uiHeading2,
)
```

##  Form / Section Components

### Section

**📐 Dimensions / Spacing**
- Default padding: 16px (lg) all directions
- Space between children: 16px (lg)
- Space below header: 16px (lg)
- Space between dividers: 16px (lg) top/bottom (Section manages automatically)

**🏗️ Structure**
- **Title**: Optional, placed at the top
- **Description**: Optional, placed 4px below title
- **Children**: Automatically divided by separators (optional)
- **Dividers**: Top/bottom borders can also be set

**🎨 Visual Style**
- Background color: Customizable (transparent by default)
- Dividers: `theme.dividerColor`
- Zoom support: Use Responsive version if necessary

**📝 Responsibility for Divider Spacing**

When `showDividers: true`, the Section component automatically inserts 16px (lg) space before and after AppDivider. AppDivider itself does not have spacing and is solely responsible for drawing the line.

```dart
// ✅ Recommended: Basic usage
Section(
  title: Text('Settings Section'),
  description: Text('Application settings items'),
  children: [
    SettingItem1(),
    SettingItem2(),
    SettingItem3(),
  ],
  showDividers: true,
)
```

### FormList

**📐 Dimensions / Spacing**
- Header padding: 8px (sm) bottom (default)
- Space between items: 8px (sm)
- Padding below last child: 8px (sm)
- Label width: 200px (default, customizable)
- Spacing between rightmost widgets: 8px (sm)

**🏗️ Structure**
- **Header row**: Title (left) + rightmost widget (right, optional)
- **Children**: List of FormItems or a single child
- **SettingsSection Compatibility**: Compatibility with existing code

**🎨 Visual Style**
- Title font: `AppTextVariant.uiBody` (default, customizable)
- Title font weight: **Bold (FontWeight.bold)**
- Zoom support: Use Responsive version if necessary

```dart
// ✅ Recommended: List of FormItems
FormList(
  title: 'Account Settings',
  labelWidth: 200,
  children: [
    FormItem(label: 'Username', child: TextField()),
    FormItem(label: 'Email Address', child: TextField()),
    FormItem(label: 'Notification Settings', child: Switch()),
  ],
)

// ✅ Recommended: Single child (SettingsSection compatible)
FormList(
  title: 'Other Settings',
  rightWidget: IconButton(icon: Icon(Icons.add)),
  child: CustomSettingsWidget(),
)
```

### FormItem

**📐 Dimensions / Spacing**
- Label width: 200px (default, customizable)
- Space between label and control: 16px (lg)
- Space above description text: 4px (xs)

**🏗️ Structure**
- **Label column**: Fixed width, left-aligned
- **Control column**: Remaining width, left-aligned
- **Description text**: Optional display below label (**generally not needed**)

**🎨 Visual Style**
- Label font: `AppTextVariant.uiBody`
- Description font: `AppTextVariant.uiCaption`
- Description color: `colorScope.disabled`
- Vertical alignment: Center

**💡 Usage Guidelines**
- **Generally avoid using `description`**: Ensure the label sufficiently explains the content
- If a description is needed, consider changing to a clearer label name
- Only use `description` if absolutely necessary

```dart
// ✅ Recommended: Basic usage (without description)
FormItem(
  label: 'Theme Color',
  child: DropdownButton<ThemeColor>(...),
)

// ✅ Recommended: Using clear label names
FormItem(
  label: 'Dark Mode (Auto-switch)',
  child: Switch(value: isDarkMode, onChanged: onChanged),
)

// ❌ Avoid: Unnecessary description
FormItem(
  label: 'Dark Mode',
  description: 'Automatically switch according to system settings', // Should be expressed by label
  child: Switch(value: isDarkMode, onChanged: onChanged),
)

// ✅ Recommended: Custom layout
FormItem(
  label: 'Custom Settings',
  labelWidth: 150,
  spacing: 12,
  child: CustomControlWidget(),
)
```

### 🎯 Usage Patterns

#### Example of Settings Screen Composition

```dart
// ✅ Recommended: Combination of Section + FormList
Section(
  children: [
    FormList(
      title: 'Account Settings',
      children: [
        FormItem(label: 'Username', child: TextField()),
        FormItem(label: 'Email Address', child: TextField()),
      ],
    ),
    FormList(
      title: 'App Settings',
      children: [
        FormItem(label: 'Theme', child: ThemeSelector()),
        FormItem(label: 'Language', child: LanguageSelector()),
      ],
    ),
  ],
  showDividers: true,
)
```

#### Responsive Design

```dart
// ✅ Recommended: Adjusting label width based on screen size
final labelWidth = MediaQuery.of(context).size.width > 600 ? 200.0 : 120.0;

FormList(
  title: 'Settings',
  labelWidth: labelWidth,
  children: [...],
)
```

#### Utilizing in Import Screen

```dart
// ✅ Recommended: Organizing import options
Section(
  title: Text('Import Settings'),
  children: [
    FormList(
      title: 'File Format',
      children: [
        FormItem(
          label: 'CSV Options',
          child: AppDropdownMenu<CsvOption>(...),
        ),
        FormItem(
          label: 'Character Encoding',
          child: AppDropdownMenu<Encoding>(...),
        ),
      ],
    ),
    FormList(
      title: 'Error Handling',
      children: [
        FormItem(
          label: 'Duplicate ID Handling',
          description: 'How to handle duplicate IDs during import',
          child: AppDropdownMenu<DuplicateHandling>(...),
        ),
        FormItem(
          label: 'Binary Files',
          description: 'How to handle binary files',
          child: AppDropdownMenu<BinaryHandling>(...),
        ),
      ],
    ),
  ],
  showDividers: true,
)
```

## 🔳 Borders, Rounded Corners, Shadows

### 🔄 Rounded Corner System

RinneGraph uses rounded corner radii according to the **importance and size of the element**:

| Size | Value | Purpose | Example Usage |
|---|---|---|---|
| **Small** | 8px | Small elements | `AppBorderRadiusValues.small`, `AppCheckbox` |
| **Medium** | 12px | Standard elements | `AppBorderRadiusValues.medium`, `AppButton`, `AppTextField` |
| **Large** | 16px | Large elements | `AppBorderRadiusValues.large`, `TagView`, Cards |
| **XLarge** | 24px | Containers, dialogs | `AppBorderRadiusValues.xlarge`, `AppDialog`, Modals |

#### 🚫 Restriction on Rounded Corner Implementation

**All rounded corner elements must use the `AppRectangleBorder` component:**

```dart
// ❌ Avoid: Direct BorderRadius usage
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(url),
  ),
)

// ✅ Recommended: Using AppRectangleBorder
AppRectangleBorder(
  cornerRadius: AppBorderRadiusValues.small, // 6px
  child: Image.network(url),
)

// ✅ Recommended: Using AppBorderRadius class
AppRectangleBorder.small(
  child: Image.network(url),
)
```

#### Reasons
- **Consistency**: Consistent design with Figma-like squircle shape
- **Quality**: High-quality rounded corner rendering with `figma_squircle`
- **Maintainability**: Centralized management of rounded corner styles
- **Accessibility**: Unified focus display

### 🖍️ Border Width

Border width expresses **visual hierarchy and state**:

| Name | Value | Purpose | Notes |
|---|---|---|---|
| **Thin** | 1px | Normal border | `TagView`, `AppDivider` |
| **Medium** | 1.5px | Accent, focus | `AppButton`, `AppSegmentedButton` |
| **Thick** | 2px | Emphasis, error state | On focus, validation errors |

### 🌟 Shadow System

Shadows visually express **content hierarchy**:

| Level | Purpose | Implementation |
|---|---|---|
| **Small** | Buttons, list items | `elevation: 1` |
| **Medium** | Cards, panels, dialogs, popovers | `elevation: 8` |
| **Large** | Modals, overlays | `elevation: 16` |

## 🎨 Icon System

### 🎯 Icon Management Policy

RinneGraph ensures visual consistency and maintainability through a **unified icon system**. All icons are centrally managed by the `AppIcons` class, enabling unified usage across the entire project.

**Basic Principles:**
- Centralized icon management
- Consistent visual style
- Accessibility support
- Dark mode/light mode support

### 📦 Icon Sources

**Primary Source:**
- **LucideIcons**: Main icon library
- Lightweight and consistent design
- Rich variations (1000+ icons)
- Vector-based for high-resolution support

**Secondary Source:**
- **Material Icons**: Flutter standard icons
- Used only if no corresponding LucideIcons exist
- Gradually transitioning to LucideIcons

### 🏗️ Implementation Structure

```dart
// ✅ Recommended: Using AppIcons class
Icon(AppIcons.search)
Icon(AppIcons.settings)

// ❌ Avoid: Direct icon usage
Icon(LucideIcons.search200)  // Avoid direct usage
Icon(Icons.search)           // Avoid direct usage
```

---

**📍 Navigation**: [← Back](./01-foundations.md) | [Next: Component Specifications →](./03-components.md)