# 08. MasterDetailLayout Design Specification

## 🎯 Overview

MasterDetailLayout is a responsive layout component that implements the master-detail pattern. It displays as a split view on desktops and in a stacked form on mobile.

## 🔲 Vertical Divider (Resize Bar) Specification

### 📐 Dimensions / Spacing

**Basic Specification:**
- **Display Width**: 2px (unified with AppVerticalDivider)
- **Tappable Area**: 10px (display width + 8px)
- **Height**: Full height of the parent container (`height: double.infinity`)
- **Minimum Display Width**: 2px (maintains this ratio even when zoomed)
- **Maximum Display Width**: 4px (upper limit for high zoom)

**Zoom Support:**
```dart
// Zoom for display width
final effectiveDisplayWidth = resizeBarWidth * accessibilityConfig.borderScale;
// 2px → 3px (1.5x) → 4px (2.0x)

// Zoom for tappable area
final effectiveTapWidth = (resizeBarWidth + 8.0) * accessibilityConfig.borderScale;
// 10px → 15px (1.5x) → 20px (2.0x)
```

### 🎨 Visual Style

**Color Priority:**
1. `resizeBarColor` (if explicitly specified)
2. `dividerColor` (if specified in MasterDetailLayout)
3. `Theme.of(context).dividerColor` (default)

**Recommended Color Specification:**
```dart
// Use default color of AppVerticalDivider
// Light theme: theme.dividerColor.withValues(alpha: 0.2) // 20% opacity
// Dark theme: theme.dividerColor.withValues(alpha: 0.2) // 20% opacity
```

**Visual Characteristics:**
- **Shape**: Straight vertical bar (uses AppVerticalDivider)
- **Edges**: Sharp edges (no rounded corners)
- **Shadow**: None
- **Border**: None

### 🖱️ Interaction Specification

**Mouse Cursor:**
- **Normal**: `SystemMouseCursors.resizeColumn`
- **Dragging**: `SystemMouseCursors.resizeColumn` (maintained)

**Drag Behavior:**
- **Direction**: Horizontal only
- **Constraints**: `minMasterWidth` to `maxMasterWidth`
- **Feedback**: Real-time resizing

**Tappable Area:**
- **Width**: 10px (2px border + 8px margin)
- **Placement**: Border centered, with margins on both sides
- **Purpose**: Ensures sufficient ease of operation even with a thin border

**Hover Effect:**
- **Implementation**: None (functions as a simple border)
- **Reason**: Functional border, no decorative elements needed

## 🏗️ Layout Structure

### Desktop Mode (width > breakpoint)

```
┌─────────────────┬─┬──────────────────────┐
│                 │ │                      │
│   Master View   │█│    Detail View       │
│                 │ │                      │
│                 │ │                      │
└─────────────────┴─┴──────────────────────┘
                   ↑
              Resize Bar (2px)
```

### Mobile Mode (width ≤ breakpoint)

```
┌──────────────────────────────────────────┐
│                                          │
│            Master View                   │
│              or                          │
│            Detail View                   │
│                                          │
└──────────────────────────────────────────┘
```

## 🎛️ Customization Options

### Basic Properties

```dart
MasterDetailLayout(
  // Border related
  resizeBarWidth: 2.0,           // Default: 2px
  resizeBarColor: Colors.grey,   // Optional
  dividerColor: Colors.grey,     // Optional (alternative to resizeBarColor)

  // Layout related
  initialMasterWidth: 280,       // Default: 280px
  minMasterWidth: 200,           // Default: 200px
  maxMasterWidth: 400,           // Default: 400px
  breakpoint: 600,               // Default: 600px
)
```

### Recommended Settings

**Standard Usage:**
```dart
MasterDetailLayout(
  resizeBarWidth: 2.0,           // Unified with AppVerticalDivider
  initialMasterWidth: 280,       // Appropriate initial width
  minMasterWidth: 200,           // Minimum display width
  maxMasterWidth: 400,           // Upper limit to prevent excessive widening
  breakpoint: 600,               // Tablet boundary
)
```

**Compact Usage:**
```dart
MasterDetailLayout(
  resizeBarWidth: 2.0,           // No change
  initialMasterWidth: 240,       // Narrower initial width
  minMasterWidth: 180,           // Narrower minimum width
  maxMasterWidth: 320,           // Narrower maximum width
  breakpoint: 768,               // Larger breakpoint
)
```

## ♿ Accessibility Support

### Zoom Support

**Border Magnification:**
- Display width scales with `borderScale` (up to 4px)
- Tappable area also scales (up to 20px)
- Ensures visual consistency while maintaining usability

**Keyboard Operation:**
- Currently unimplemented (future extension point)
- Consideration of resize operation with arrow keys

### Visual Considerations

**High Contrast Support:**
- Uses system theme `dividerColor`
- Ensures sufficient contrast even with custom color specifications

## 🚫 Implementations to Avoid

### ❌ Inappropriate Width Settings

```dart
// Width outside standard
MasterDetailLayout(resizeBarWidth: 1.0)  // 1px (too thin)
MasterDetailLayout(resizeBarWidth: 3.0)  // 3px (half-baked)
MasterDetailLayout(resizeBarWidth: 4.0)  // 4px (old spec, deprecated)

// Excessively thick border
MasterDetailLayout(resizeBarWidth: 8.0)  // 8px (visually too heavy)
```

### ❌ Inappropriate Color Settings

```dart
// Too low visibility
MasterDetailLayout(
  resizeBarColor: Colors.grey.withValues(alpha: 0.05), // 5% opacity
)

// Too prominent
MasterDetailLayout(
  resizeBarColor: Colors.blue,              // Too strong color
  resizeBarWidth: 8.0,                      // Too thick width
)
```

## 🔄 Consistency with Other Components

### Relationship with AppVerticalDivider

**Similarities:**
- 4px grid system compliant
- Automatic application of theme colors
- Zoom support

**Differences:**
- MasterDetailLayout: Includes resize functionality, encapsulates AppVerticalDivider
- AppVerticalDivider: Static divider, 2px standard thickness

### Integration with MainShellLayout

When using MasterDetailLayout within MainShellLayout:

```dart
MainShellLayout(
  content: MasterDetailLayout(
    resizeBarWidth: 2.0,        // Unified with MainShellLayout's border
    // Other settings...
  ),
)
```

---

**📍 Navigation**: [← Back](./07-button-roles-and-sizing.md) | [Next: Color Design Guidelines →](./09-color-design-guidelines.md)