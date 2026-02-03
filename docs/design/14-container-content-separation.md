# Container-Content Separation Design Principles

## 🎯 Overview

This document defines the design philosophy of **"container" and "content" separation** in RinneGraph. This principle aims to achieve both a sophisticated macOS-like UI and high information density.

## 🏗️ Core Idea

### Design Philosophy
Following macOS UI design philosophy, UI elements are clearly classified into **"container"** and **"content"**, and appropriate padding strategies are applied to each.

```
"Is this element information that the user directly interacts with or views?"

→ Yes: Content (sufficient padding)
→ No:  Container (minimal padding)
```

### Core Principles
- **Container**: Structural elements that define the UI framework → **Minimal padding**
- **Content**: Information elements that the user interacts with or views → **Sufficient padding**

## 📦 Container

### Definition
A structural element that defines the UI's framework and serves to position and separate other elements.

### Characteristics
- **Padding**: Minimal in principle (often zero)
- **Purpose**: To reach the edges of windows and panels, clarifying the structure
- **Visual Effects**: Boundaries and background colors are used to delineate areas

### Representative Examples

| UI Element | Description | Padding Strategy |
|---|---|---|
| **Toolbar** | Operational area at the top of the window | Padding only for internal elements |
| **Sidebar** | Navigation/list display area | List items extend to the edge |
| **Window Frame** | Outermost shell of the application | Managed by OS, app does not intervene |
| **Panel Boundary** | Outer frame of settings panel, inspector | Internal content manages padding |
| **Divider** | Boundary between sections | Line itself has no padding |

### Implementation Pattern
```dart
// ✅ Example of container implementation
Container(
  // No padding - extends to the boundary
  decoration: BoxDecoration(
    border: Border(bottom: BorderSide(...)),
  ),
  child: Row(
    children: [
      // Internal elements manage padding individually
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: IconButton(...),
      ),
    ],
  ),
)
```

## 📄 Content

### Definition
Information elements that the user directly interacts with, views, or inputs.

### Characteristics
- **Padding**: Sufficient margins are ensured
- **Purpose**: To improve readability, usability, and focus
- **Visual Effects**: Provides "breathing room"

### Representative Examples

| UI Element | Description | Padding Strategy |
|---|---|---|
| **Text Editor** | Document editing area | Sufficient margins in all directions |
| **Form** | Group of input fields | Appropriate spacing for each item |
| **Inspector Content** | Property editing controls | Organized with grouping and margins |
| **Dialog Content** | Text/buttons within a modal | Margins prioritized for readability |
| **List Item Content** | Icon, text, button | Appropriate placement within the item |

### Implementation Pattern
```dart
// ✅ Example of content implementation
Container(
  padding: EdgeInsets.all(AppSpacingValues.lg), // 16px
  child: Column(
    children: [
      Text('Text for the user to read'),
      SizedBox(height: AppSpacingValues.md), // 12px
      TextField(...),
    ],
  ),
)
```

## 📐 Specific Padding Values

### 4px Grid System Compliant

| Usage Category | Recommended Value | Token | Example Usage |
|---|---|---|---|
| **Container Internal** | 0px | - | Toolbar, sidebar outer frame |
| **Container Element** | 8-12px | sm-md | Toolbar internal buttons, within list items |
| **Content Basic** | 16px | lg | Forms, inspector, general content |
| **Content Important** | 24-32px | xxl-xxxl | Dialogs, main editor |

### Detailed Specifications by Layout

#### Dialogs / Panels
```dart
// Header / Content area
padding: EdgeInsets.all(AppSpacingValues.xxxl), // 32px

// Action area
padding: EdgeInsets.all(AppSpacingValues.lg),   // 16px
```

#### Toolbar
```dart
// Toolbar itself: No padding
// Padding only for internal elements
padding: EdgeInsets.symmetric(
  horizontal: AppSpacingValues.md, // 12px
  vertical: AppSpacingValues.sm,   // 8px
),
```

#### Sidebar
```dart
// Sidebar itself: No padding
// Padding only for content within list items
padding: EdgeInsets.symmetric(
  horizontal: AppSpacingValues.md, // 12px
  vertical: AppSpacingValues.sm,   // 8px
),
```

#### Inspector / Forms
```dart
// Overall padding
padding: EdgeInsets.all(AppSpacingValues.lg), // 16px

// Spacing between items
spacing: AppSpacingValues.md, // 12px
```

## 🎨 Visual Judgment Criteria

### Container Characteristics
- **Extends to boundary**: Touches the edge of the window/panel
- **Structural role**: Positions and organizes other elements
- **Background / Border**: Clearly defines area separation

### Content Characteristics
- **Surrounded by whitespace**: Has breathing room around it
- **Informational role**: Information that the user consumes or interacts with
- **Focusable**: Often directly interactable by the user

## 🔍 Practical Decision Flow

### Step 1: Identify Element Role
```
What is the primary purpose of this element?
├─ To position/separate other elements → Container
└─ To display information/receive input → Content
```

### Step 2: Confirm Relationship with User
```
How does the user relate to this element?
├─ Does not directly interact (only views/passes through) → Container
└─ Directly interacts (reads/inputs/clicks) → Content
```

### Step 3: Determine Padding Strategy
```
Container → Minimal padding (often 0px)
Content → Sufficient padding (16px-32px)
```

## 📋 Implementation Checklist

### Design Review Items
- [ ] Have UI elements been categorized as container/content?
- [ ] Do container elements extend to the boundary?
- [ ] Do content elements have sufficient margins?
- [ ] Is it compliant with the 4px grid system?

### Code Implementation Review Items
- [ ] Are `AppSpacingValues` constants used?
- [ ] Is excessive padding not set on containers?
- [ ] Is content readability and usability ensured?
- [ ] Is a consistent padding strategy applied?

## 🚨 Common Mistakes

### ❌ Patterns to Avoid

```dart
// Excessive padding on a container
Container(
  padding: EdgeInsets.all(20), // Unnecessary padding on toolbar
  child: Toolbar(...),
)

// Insufficient padding for content
Container(
  padding: EdgeInsets.all(4), // Insufficient padding for text area
  child: TextEditor(...),
)
```

### ✅ Recommended Patterns

```dart
// Container: Focus on structure
Container(
  decoration: BoxDecoration(border: ...),
  child: Row(
    children: [
      // Internal elements manage padding individually
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Button(...),
      ),
    ],
  ),
)

// Content: Sufficient margins
Container(
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('Easy-to-read text'),
      TextField('Easy-to-operate input field'),
    ],
  ),
)
```

## 🎯 Expected Effects

### Improved User Experience
- **Clear Structure**: UI hierarchy is intuitively understood
- **Improved Usability**: Content is placed in an easy-to-operate position
- **Visual Comfort**: Reduced fatigue due to appropriate margins

### Improved Development Efficiency
- **Consistent Decision Criteria**: Reduced ambiguity in padding settings
- **Improved Maintainability**: Clear design intent makes modifications easier
- **Improved Quality**: Achieves sophisticated macOS-like UI

---

**📍 Navigation**: [← Previous: Panel Layout Guidelines](./13-panel-layout-guidelines.md) | [Next: README](./README.md)