# 11. Main Area Toolbar Design Guidelines

## 🎯 Overview

The main area toolbar is an operational panel located at the top of the main content area of each screen. It provides screen-specific functions and navigation elements with a unified design.

### 📍 Placement
- **Position**: Topmost part of the main content area
- **Relationship**: Directly below the title bar, directly above the content area
- **Width**: Corresponds to the full width of the main content area

## 🏗️ Basic Structure

### 📐 Dimensions / Spacing

**Height**
- **Standard height**: 48px (fixed)
- **Minimum height**: 48px (maintained regardless of content)

**Padding**
- **Horizontal padding**: 16px (left/right)
- **Vertical padding**: 8px (top/bottom)
- **Internal element spacing**: 8px to 24px (adjusted according to element importance)

**Border**
- **Bottom border**: 1px solid (`base.border`)
- **Top border**: None (boundary with title bar is existing)

### 🎨 Visual Style

**Background color**
- **Normal**: `uiAreas.panel.background`
- **Hover effect**: None (toolbar itself has no interaction)

**Border color**
- **Bottom border**: `base.border`

## 🧩 Component Configuration

### 🔄 Layout Pattern

**Basic Layout**
```
[Left-aligned elements] ────────── [Right-aligned elements]
```

**Left-aligned elements (Primary Actions)**
- **Display mode switching**: Segmented buttons (table/graph/chart)
- **Main operations**: Core function buttons of the screen
- **Filter**: Data filtering function

**Right-aligned elements (Secondary Actions)**
- **Filter**: Data filtering function (search field + overflow menu)
- **Display settings**: Zoom, layout change
- **Auxiliary operations**: Export, settings, etc.
- **Status display**: Number of selections, data count, etc.

### 📱 Responsive Design

**Element Priority**
1. **Highest priority**: Display mode switching (always visible)
2. **High priority**: Filter function (search field always visible)
3. **Medium priority**: Main operation buttons, auxiliary operation buttons
4. **Low priority**: Status display text

**Handling insufficient space**
- Low priority elements are hidden sequentially
- Filter overflow menu remains always visible
- Consolidation into overflow menu
- Display icons only (omit labels)

## 🎛️ Operational Element Specifications

### 🔘 Segmented Buttons (Display Mode Switching)

**Placement**: Leftmost (highest priority)
**Component**: `AppSegmentedButton`
**Size**: Standard size (Flutter compliant)
**Icon size**: 18px

**Display Modes**
- **Table**: `AppIcons.table`
- **Graph**: `AppIcons.graphNavigation`
- **Chart**: `AppIcons.barChart`

### 🔧 Operation Button Group

**Graph Operation Tools (Displayed only in graph mode)**
- **Zoom in**: `Icons.zoom_in` (18px)
- **Zoom out**: `Icons.zoom_out` (18px)
- **Reset zoom**: `Icons.center_focus_strong` (18px)
- **Fit to screen**: `Icons.fit_screen` (18px)

**Button specifications**
- **Size**: 28x28px (minimum constraint)
- **Icon size**: 18px
- **Splash radius**: 16px
- **Padding**: Zero
- **Spacing**: 4px

### 📋 Layout Selection

**Component**: `PopupMenuButton`
**Trigger icon**: Current layout icon (18px)
**Menu items**: Icon (16px) + Text + 8px spacing

**Layout Types**
- **Force**: `Icons.shuffle`
- **Circle**: `AppIcons.circle`
- **Tree**: `Icons.account_tree`
- **Grid**: `Icons.grid_3x3`
- **Hierarchical**: `Icons.device_hub`

### 🔍 Filter Function (Common to Charts)

**Placement**: Rightmost (highest priority right-aligned element)
**Composition**: Search field + overflow menu icon button
**Purpose**: Filter displayed data

#### Search field

**Component**: `AppTextField`
**Size**: Width 200px (fixed), height 32px (toolbar standard)
**Placeholder**: "Filter..."
**Icon**: `prefixIcon: Icon(Icons.search, size: 18)`

**Visual style**
- Rounded corners: 12px (medium)
- Border: 1.5px
- Background: Transparent
- On focus: Border emphasized with `focusBorder` color

#### Overflow menu icon button

**Component**: `OverflowMenu` (based on PopupMenuButton)
**Icon**: `Icons.filter_list` (18px)
**Placement**: Next to search field (8px spacing)
**Tooltip**: "Filter settings"

**Button specifications**
- Size: 32x32px (height unified with search field)
- Icon size: 18px
- Padding: Zero
- Rounded corners: 8px

#### Overflow menu structure

**Entire menu**
- Max width: 320px
- Height: Auto-adjusted according to content (no scroll needed if fits on screen)
- Rounded corners: 8px
- Shadow: Standard popup shadow

**Section configuration (top to bottom)**

1.  **Node label section**
    - Section title: "Node labels"
    - Item format: Checkbox + label name
    - Max display items: 10 items (scrollable)

2.  **Divider**: `Divider` (1px, `base.border` color)

3.  **Link type section**
    - Section title: "Link types"
    - Item format: Checkbox + link type name
    - Max display items: 10 items (scrollable)

4.  **Divider**: `Divider` (1px, `base.border` color)

5.  **Property section**
    - Section title: "Properties"
    - Item format: Checkbox + property name
    - Max display items: 15 items (scrollable)

6.  **Divider**: `Divider` (1px, `base.border` color)

7.  **Action section**
    - Section title: "Actions"
    - Items: "Select All", "Nodes Only", "Links Only", "Reset"
    - Format: Text button (no checkbox)

#### Menu Item Specifications

**Checkbox items**
- Component: `AppCheckbox` (16px) + `AppText`
- Layout: Horizontal arrangement (8px spacing)
- Padding: 8px vertical, 12px horizontal
- Hover effect: Background color change

**Section title**
- Font: `AppTextVariant.uiSmall`
- Color: `base.foreground.withAlpha(179)` (auxiliary text color)
- Padding: 4px vertical, 12px horizontal
- Background: `uiAreas.panel.background`

**Action items**
- Component: `TextButton`
- Font: `AppTextVariant.uiBody`
- Color: `theme.primaryColor`
- Padding: 8px vertical, 12px horizontal
- Minimum height: 32px

#### Operation Specifications

**Search field**
- Real-time search (filtering immediately on input)
- Case-insensitive
- Partial match search
- Confirm with Enter key (optional)

**Checkbox items**
- Multiple selections possible
- Initial state: All selected
- Deselecting triggers filtering

**Action items**
- **Select All**: Turns ON all checkboxes
- **Nodes Only**: Selects only node labels, deselects all link types
- **Links Only**: Selects only link types, deselects all node labels
- **Reset**: Returns to all selected state + clears search field

## 🎨 Color System

### 🌈 Color Application

**Background colors**
- **Toolbar background**: `uiAreas.panel.background`
- **Button background**: Transparent (visible only on hover)

**Text and icon colors**
- **Normal state**: `base.foreground`
- **Disabled state**: `base.foreground.withAlpha(128)`
- **Hover state**: `base.foreground` (expressed by background color change)

**Border colors**
- **Toolbar bottom border**: `base.border`
- **Segmented button**: `AppSegmentedButton`'s standard color

### 🌓 Dark Mode Support

**Automatic switching**
- Automatic support via `effectiveColorSchemeProvider`
- Manual color specification prohibited
- Synchronization with system settings

## ♿ Accessibility

### ⌨️ Keyboard Navigation

**Tab order**
1. Display mode switching (segmented button)
2. Graph operation tools (left to right)
3. Layout selection
4. Other operational elements

**Keyboard shortcuts**
- **Tab**: Move focus to the next element
- **Shift+Tab**: Move focus to the previous element
- **Enter/Space**: Execute button
- **Arrow keys**: Move selection within segmented button

### 🔍 Zoom Support

**Scaling targets**
- Icon size: 18px → 18px * zoomScale
- Button size: 28px → 28px * zoomScale
- Spacing: 4px → 4px * zoomScale
- Padding: 8px → 8px * zoomScale
- Filter search field width: 200px → 200px * zoomScale
- Checkbox size: 16px → 16px * zoomScale

**Fixed elements**
- Toolbar height: 48px (fixed)
- Border width: 1px (fixed)
- Filter menu max width: 320px (fixed)

### 🏷️ Semantic Information

**Tooltips**
- Mandatory for all operational elements
- Concise and easy-to-understand descriptions
- If keyboard shortcuts exist, include them
- Filter search field: "Filter..."
- Filter menu button: "Filter settings"

**ARIA attributes**
- `role="toolbar"`: Entire toolbar
- `aria-label`: Description for each button
- `aria-pressed`: Selection state of segmented button
- `role="menu"`: Filter overflow menu
- `role="menuitem"`: Each item in the menu

## 🚫 Constraints

### ❌ Prohibited

**Animations**
- Prohibit animations for toolbar elements
- Prohibit display/hide transition animations
- Prohibit hover effect animations

**Use of fixed values**
- Prohibit hardcoded color usage
- Prohibit direct specification of fixed sizes (design tokens must be used)
- Prohibit platform-specific styles

**Layout**
- Prohibit vertical scrolling (fixed height)
- Prohibit duplicate element display
- Prohibit inappropriate element spacing

### ⚠️ Notes

**Performance**
- Avoid unnecessary rebuilds
- Minimal updates on state changes
- Prevent memory leaks

**Consistency**
- Maintain consistency with toolbars on other screens
- Strict application of design tokens
- Adherence to component specifications

## 📋 Implementation Checklist

### ✅ Mandatory Check Items

**Design**
- [ ] Fixed height 48px
- [ ] Horizontal padding 16px
- [ ] Bottom border 1px
- [ ] Background color `uiAreas.panel.background`

**Functionality**
- [ ] Display mode switching aligned to the left
- [ ] Filter function aligned to the right
- [ ] Filter search field (200px width)
- [ ] Filter overflow menu (4-section configuration)
- [ ] Conditional display of graph operation tools
- [ ] Appropriate placement of layout selection
- [ ] Keyboard navigation support

**Accessibility**
- [ ] Tooltips set for all elements
- [ ] ARIA attributes set for filter elements
- [ ] Keyboard navigation for filter menu
- [ ] Zoom function supported
- [ ] Appropriate ARIA attributes set
- [ ] Keyboard operation supported

**Quality**
- [ ] Use of design tokens
- [ ] Animations disabled
- [ ] Performance optimized
- [ ] Consistency with other screens

---

**📍 Navigation**: [← Previous: Table View Design Guidelines](./10-table-view-guidelines.md) | [Next: Undefined →](#)