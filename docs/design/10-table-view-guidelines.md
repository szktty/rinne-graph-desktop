# 10. Table View Design Guidelines

## 🎯 Overview

The table view is a component for efficiently displaying and manipulating structured data. RinneGraph provides a table view optimized for mouse and keyboard operations, based on a desktop-first design philosophy.

### 🏛️ Design Principles

**1. Optimization of Information Density**
- Efficient use of space in a desktop environment
- Displaying a lot of information by utilizing vertical space
- Ensuring readability with appropriate row spacing

**2. Intuitive Operability**
- Precise column operations with mouse (resize, reorder)
- Keyboard navigation support
- Consistent interaction patterns

**3. Emphasis on Accessibility**
- WCAG 2.1 AA compliant
- Zoom functionality (100%-200%)
- Screen reader support

**4. Performance Optimization**
- Efficient display of large amounts of data
- Optimized rendering through virtualization
- Minimal rebuilds

## 📐 Layout Specifications

### 🏗️ Basic Structure

```
┌─ Table Container ──────────────────────────┐
│ ┌─ Header Row ──────────────────────────┐ │
│ │ Column 1 │ Column 2 │ Column 3 │ ... │ Resize Handle │ │
│ └───────────────────────────────────────┘ │
│ ┌─ Data Row ────────────────────────────┐ │
│ │ Cell 1 │ Cell 2 │ Cell 3 │ ...         │ │
│ │ Cell 1 │ Cell 2 │ Cell 3 │ ...         │ │
│ │ ...                                    │ │
│ └───────────────────────────────────────┘ │
│ ┌─ Scrollbar ──────────────────────────┐ │
│ │ Vertical Scroll │ Horizontal Scroll │ │
│ └───────────────────────────────────────┘ │
└───────────────────────────────────────────┘
```

### 📏 Dimensions / Spacing

**Overall Table**
- Outer border: 1px (`AppColorScheme.base.border`)
- Background color: `AppColorScheme.base.background`

**Header Row**
- Height: 32px (desktop optimized)
- Horizontal padding: 12px (cell content)
- Vertical padding: 8px
- Font: `AppTextVariant.uiCaption` (14px, Medium)

**Data Row**
- Height: 28px (emphasizing information density)
- Horizontal padding: 12px (cell content)
- Vertical padding: 6px
- Font: `AppTextVariant.uiCaption` (14px, Regular)

**Column Separator**
- Vertical border: 0px
- Horizontal border: 1px (`AppColorScheme.base.border`)

## 🎨 Visual Design

### 🌈 Color System

> **Important**: In table view, do not use transparency (alpha values); define and use dedicated color tokens. This ensures consistency and accessibility during theme switching.

**Background Colors**
- Table background: `AppColorScheme.appSpecific.table.background`
- Header background: `AppColorScheme.appSpecific.table.headerBackground`
- Odd row: `AppColorScheme.appSpecific.table.oddRowBackground`
- Even row: `AppColorScheme.appSpecific.table.evenRowBackground`
- Selected row: `AppColorScheme.appSpecific.table.selectedRowBackground`
- Hover row: `AppColorScheme.appSpecific.table.hoverRowBackground`
- Active row: `AppColorScheme.appSpecific.table.activeRowBackground`

> **Note**: For odd and even row backgrounds, use colors that are clearly distinguishable for accessibility. Do not use transparency; use dedicated color tokens.

**Text Colors**
- Header text: `AppColorScheme.appSpecific.table.headerText`
- Cell text: `AppColorScheme.appSpecific.table.cellText`
- Selected text: `AppColorScheme.appSpecific.table.selectedRowText`

**Border Colors**
- Normal border: `AppColorScheme.appSpecific.table.border`
- Active border: `AppColorScheme.appSpecific.table.activeBorder`
- Inactive border: `AppColorScheme.appSpecific.table.border`

### 🎭 State Representation

**Row States**
- **Normal**: Default background color (`oddRowBackground` / `evenRowBackground`)
- **Hover**: `AppColorScheme.appSpecific.table.hoverRowBackground`
- **Selected**: `AppColorScheme.appSpecific.table.selectedRowBackground`
- **Active**: `AppColorScheme.appSpecific.table.activeRowBackground`
- **Focus**: `AppColorScheme.appSpecific.table.activeBorder`

**Column States**
- **Normal**: Default header style
- **Sorting**: Display sort indicator
- **Resizing**: Cursor change and preview display
- **Dragging**: Semi-transparent display and insertion point indicator

## 🖱️ Interaction Specifications

### 📋 Selection Function

**Single Selection (Default)**
- Click: Select row
- Cmd+Click: Deselect
- Arrow keys: Move selection

**Multiple Selection (Optional)**
- Cmd+Click: Add to selection
- Shift+Click: Range selection
- Cmd+A: Select all

### 🔄 Column Operations

**Column Resize**
- Resize handle: On column boundary (8px wide tap area)
- Cursor: `col-resize`
- Minimum width: 50px (default)
- Maximum width: No limit (default)
- Real-time preview: Enabled

**Column Reorder**
- Start drag: Click+drag header
- Dragging display: Semi-transparent column + insertion point indicator
- Drop area: Between other column headers
- Animation: Disabled (performance prioritized)

**Column Sort**
- Click: Toggle sort (Ascending → Descending → None)
- Indicator: Arrow icon (▲▼)
- Multi-column sort: Not supported (simplicity prioritized)

### 📜 Scroll Function

**Scrollbar**
- Display: Always shown (`isAlwaysShown: true`)
- Thickness: 8px (normal), 10px (dragging)
- Zoom support: Thickness also linked to zoom magnification
- Position: Right edge (vertical), bottom edge (horizontal)

**Scroll Behavior**
- Mouse wheel: Vertical scroll
- Shift+Mouse wheel: Horizontal scroll
- Keyboard: Arrow keys, Page Up/Down, Home/End
- Smooth scroll: Disabled (performance prioritized)

## ♿ Accessibility

### 🔍 Zoom Support

**Scaling Elements**
- Font size: `AppTextVariant.uiCaption` (zoom compatible)
- Scrollbar thickness: `8px * zoomScale`
- Border width: `1px * borderScale`
- Padding: Fixed value (to prevent layout collapse)

**Zoom Range**
- Minimum: 100%
- Maximum: 200%
- Increment: 25%

### ⌨️ Keyboard Navigation

**Basic Operations**
- Tab: Next focusable element
- Shift+Tab: Previous focusable element
- Enter: Select row / Execute action
- Space: Toggle row selection

**Row Movement**
- ↑↓: Move row
- Page Up/Down: Page-by-page movement
- Home/End: First/last row
- Cmd+Home/End: Top/bottom of table

**Column Operations**
- ←→: Move column (when header is focused)
- Enter: Execute sort (when header is focused)

### 🔊 Screen Reader Support

**Semantic Structure**
- `role="table"`: Table element
- `role="columnheader"`: Column header
- `role="row"`: Row element
- `role="cell"`: Cell element

**ARIA Attributes**
- `aria-label`: Table description
- `aria-sort`: Sort state
- `aria-selected`: Selected state
- `aria-rowindex`: Row number
- `aria-colindex`: Column number

## 🚀 Performance Considerations

### 📊 Large Data Support

**Virtualization**
- Rows outside the display area are not rendered
- Dynamic rendering during scrolling
- Optimized memory usage

**Rendering Optimization**
- Suppress unnecessary rebuilds
- Efficient updating of cell content
- Disable animations

### 🔧 Implementation Recommendations

**Data Structure**
- Use immutable objects
- Efficient key extraction functions
- Proper `equals` and `hashCode` implementations

**State Management**
- Separate selection states
- Persist column settings
- Manage sort states

---

**📍 Navigation**: [← Back](./09-color-design-guidelines.md) | [Next: README →](./README.md)