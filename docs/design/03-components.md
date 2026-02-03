# 03. Component Specifications

## 🔘 Interactive Components

### AppButton

**📐 Dimensions / Spacing**
- Minimum height: 32px (8x4px unit, desktop optimized)
- Horizontal padding: 16px (lg)
- Vertical padding: 6px (12px total top/bottom)
- Icon spacing: 4px (xs)

**🎨 Visual Style**
- Border: 1.5px (accent)
- Rounded corners: 12px (medium)
- Font: `AppTextVariant.uiBody`

**🎭 State Management**
- **Normal**: `backgroundColor`, `borderColor`
- **Hover**: `buttonBackgroundHover`
- **Press**: `buttonBackgroundActive`
- **Focus**: `focusBorder`
- **Disabled**: 50% opacity

### AppDropdownMenu

**📐 Dimensions / Spacing (Compliant with AppButton)**
- Minimum height: 32px (same as AppButton)
- Horizontal padding: 16px (lg) (same as AppButton)
- Vertical padding: 6px (same as AppButton)
- Icon spacing: 4px (xs)
- Rounded corners: 12px (same as AppButton)

**🎨 Visual Characteristics**
- **Overlay Menu**: Design that completely covers the button when selected
- **Checkmark**: Displays a check icon for selected items
- **Hover Effect**: Background color change when hovering over menu items
- **Zoom Support**: Automatically adapts to accessibility settings

**🔧 Technical Specifications**
- **Border width**: 1.5px (ensures visibility when focused)
- **Checkbox space**: 16px
- **Chevron icon size**: 16px
- **Check icon size**: 12px
- **Standard icon size**: 24px (leading/trailing)

**📱 Desktop Optimization**
- **Unified Height**: 32px, same as AppButton, for visual consistency
- **Unified Padding**: 16px horizontal, 6px vertical, same feel as buttons
- **Efficient Space Usage**: Optimized information density for desktop

### AppSegmentedButton

**📐 Dimensions / Spacing**
- Height: Compliant with Flutter standard
- Border: 1.5px
- Text: Zoom-responsive font size

**🎨 Colors**
- Background: `sidebarBackground`
- Selected background: `segmentedButtonSelectedBackground`
- Text: `sidebarInactiveItemText` / `sidebarActiveItemText`
- Border: `accentColor`

## 📝 Input Components

### AppTextField

**📐 Dimensions / Spacing**
- Height: 32px (desktop standard)
- Horizontal padding: 16px (lg)
- Vertical padding: 6px
- Rounded corners: 12px (medium)

**🎨 Visual Style**
- Normal border: 1.5px
- Focus border: 2px (thick)
- Background: Transparent or `surface`

**🎭 State Management**
- **Normal**: `controlBorder`
- **Focus**: `controlFocusBorder`
- **Error**: `notificationError`
- **Disabled**: `controlDisabledBorder`

### AppCheckbox

**📐 Dimensions**
- Size: 20px (5x4px unit)
- Rounded corners: 4px (xs)
- Border: 1px

**🎨 Visuals**
- Checkmark: Animated
- Color: `accentColor`

## 📦 Container Components

### SelectableCard

**📐 Dimensions / Spacing**
- Margin: 4px (xs) all directions
- Rounded corners: Default (usually 8px)
- Elevation: 1px (small shadow)

**🎭 State Management**
- **Normal**: `cardColor`
- **Selected**: `selectedCardBackground` or `highlightColor.withAlpha(77)`
- **Hover**: Subtle elevation change

**🖱️ Interactions**
- Single tap: `onTap`
- Double tap: `onDoubleTap` (custom detection)
- Tap down: `onTapDown` (immediate feedback)

### AppContainer

**📐 Layout**
- Horizontal padding: 16px (lg)
- Vertical padding: 8px (sm)
- `leadingWidget` width: 16px (lg) (default)

**🎨 Background Color**
- Default background color: `sidebarBackground` (theme automatically applied)
- Custom background color: Can be overridden with `color` property
- When `decoration` is specified: `decoration` property takes precedence

**🏗️ Structure**
- When `leadingWidget` is used: Row structure, automatic layout adjustment
- Normal usage: Standard padding applied
- Background color: Theme color automatically applied when `color` or `decoration` is not specified

**💡 Recommended Usage**
- Prioritize `AppContainer` over `Container` in design guideline compliant areas
- Unified padding and automatic theme-responsive background color
- Accessibility support (zoom function)

### SettingsSection

**📐 Layout**
- Header padding: 8px (sm) bottom (default)
- Text alignment: Left-aligned
- Font: `AppTextVariant.uiBody`

**🏗️ Structure**
- Header row: `Row` layout with text on the left, optional widget on the right
- Child widgets: Placed below header with padding
- Zoom support: Use Responsive version if necessary

**🎭 Purpose**
- Section division on settings screens
- Combination of header text and action buttons
- Grouping form items

## 🏷️ Display Components

### StackGrid

**📐 Dimensions / Spacing**
- Card spacing (horizontal): 24px (crossAxisSpacing)
- Card spacing (vertical): 20px (mainAxisSpacing)
- Grid columns: 3 columns (default)
- Grid rows: 2 rows (default)

**🎨 Aspect Ratio Specification**
- **Fixed aspect ratio**: 4:3 (1.33) (default)
- **Design philosophy**: Ensures visual consistency when using arbitrary images as thumbnails
- **Calculation method**: Card size is determined based on available width, and height is calculated with a fixed aspect ratio

**🏗️ Layout Structure**
- **Thumbnail section**: 3/5 (60%) of card height
- **Information section**: 2/5 (40%) of card height
- **Pagination**: Page indicator + navigation buttons

**🎭 State Management**
- **Selection state**: Unified selection display by SelectableCard component
- **Empty state**: Customizable empty state widget
- **Loading state**: Customizable loading widget

**💡 Recommended Usage**
- **Utilize fixed aspect ratio**: Use `fixedAspectRatio: 4/3` (default)
- **Custom aspect ratio**: Adjustable with `fixedAspectRatio` parameter for special uses
- **Traditional dynamic calculation**: `fixedAspectRatio: null` also allows calculation based on parent widget size

### TagView

**📐 Dimensions / Spacing**
- Horizontal padding: 12px (md)
- Vertical padding: 4px (xs)
- Rounded corners: 16px (large)
- Border: 1px

**🎨 Visual Style**
- Background: `color.withAlpha(26)` (light)
- Border: `color.withAlpha(51)` (strong)
- Text: `color`
- Font: `labelSmall`

### AppDivider

**📐 Dimensions**
- Thickness: Customizable (default 1px)
- Indent: Customizable

**🎨 Color**
- Color: `theme.dividerColor.withAlpha(51)` (20% opacity)
- Zoom support: Use Responsive version if necessary

**🏗️ Responsibility for Spacing**

AppDivider is solely responsible for "drawing a line", and the surrounding spacing is managed by the user.

**Recommended Usage Pattern:**

1. **Within Section Component (Recommended)**
   ```dart
   Section(
     showDividers: true,
     children: [widget1, widget2, widget3],
   )
   ```
   → Section automatically inserts 16px (lg) space before and after the divider

2. **Manual Layout**
   ```dart
   Column(
     children: [
       widget1,
       AppSpacing.verticalLg,  // 16px
       AppDivider(),
       AppSpacing.verticalLg,  // 16px
       widget2,
     ],
   )
   ```

**❌ Avoid:**
```dart
// Direct placement without spacing (visually too dense)
Column(children: [widget1, AppDivider(), widget2])
```

## 🧩 Component-Specific Spacing Specifications

The following are standard spacing values for major components. **Use Responsive versions if zoom support is required**.

### 🔘 Button Components

| Component | Horizontal | Vertical | Height | Other |
|---|---|---|---|---|
| **AppButton** | `AppPadding.lg` (16px) | 6px | 32px | Icon spacing: `AppSpacing.xs` |
| **AppSegmentedButton** | - | - | - | Border: 1.5px |
| **AppIconButton** | `AppPadding.sm` (8px) | `AppPadding.sm` (8px) | 32px | Icon size: 24px |

### 📦 Container Components

| Component | Horizontal | Vertical | Special Notes |
|---|---|---|---|
| **AppContainer** | `AppPadding.lg` (16px) | `AppPadding.sm` (8px) | `leadingWidget` support |
| **SelectableCard** | - | - | Margin: `AppPadding.xs`, Elevation: 1px |
| **AppDialog** | `AppPadding.xxxl` (32px) | `AppPadding.xxxl` (32px) | Rounded corners: 16px, Details: [Panel Layout Guidelines](./13-panel-layout-guidelines.md) |

### 🏷️ Display Components

| Component | Horizontal | Vertical | Rounded Corners | Special Notes |
|---|---|---|---|---|
| **StackGrid** | 24px (crossAxisSpacing) | 20px (mainAxisSpacing) | - | Fixed aspect ratio: 4:3 |
| **TagView** | `AppPadding.md` (12px) | `AppPadding.xs` (4px) | 16px | Border: 1px |
| **AppDivider** | - | - | - | Thickness: 1px |

### 📝 Input Components

| Component | Horizontal | Vertical | Height | Rounded Corners |
|---|---|---|---|---|
| **AppTextField** | `AppPadding.lg` (16px) | 6px | 32px | 12px |

**⚠️ Important Restrictions**
- **Label text discouraged**: Label text cannot be used due to 36px height constraint
- **InputDecoration not supported**: Uses dedicated properties to enforce app-specific design
- **Available properties**: `hintText`, `errorText`, `prefixIcon`, `suffixIcon`
| **AppDropdownMenu** | `AppPadding.lg` (16px) | 6px | 32px | 12px |
| **AppCheckbox** | - | - | 20px | 4px |

---

**📍 Navigation**: [← Back](./02-design-tokens.md) | [Next: Implementation Guide →](./04-implementation.md)