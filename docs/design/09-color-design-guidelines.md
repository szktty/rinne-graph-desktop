# 09. Color Design Guidelines

## 🎨 Overview

These guidelines define the rules and recommendations for ensuring consistency and uniformity in color design during the **preset theme design** of RinneGraph. The aim is to achieve a sense of unity with a small number of colors and reduce user discomfort, especially in the design of preset colors (light mode and dark mode).

## ⚠️ Important Notes

**The scope of these guidelines is very limited:**

- **Target**: Only for **designing** preset themes
- **Not Target**: For **using** color schemes (during implementation)
- **Situations to Refer**: When defining colors within `AppColorScheme.fromColorScheme()`
- **Situations Not to Refer**: During widget implementation, component development

**When implementing, always use color scheme properties (e.g., `AppColorScheme.uiAreas.*`).**

## 🎯 Basic Principles of Preset Theme Design

### 1. Minimize Number of Colors
- **Elite Few**: Achieve maximum expressiveness with the minimum necessary number of colors
- **Unity**: Use the same color for similar purposes
- **Hierarchy**: Express visual hierarchy through color lightness and saturation

### 2. Restriction on Transparency
- **Basically Prohibited**: Do not apply multiple transparencies to primary colors
- **Exception**: Only `Colors.transparent` is allowed
- **Alternative**: Create dedicated color definitions

### 3. Semantic Color Usage
- **Consistency of Meaning**: Use the same color for elements with the same meaning
- **Contextual Consideration**: Select appropriate colors according to the usage scenario
- **Accessibility**: Ensure WCAG 2.1 AA compliant contrast ratio

## 🏗️ Color Integration Rules

### Background Color Optimization

#### Background Color Restrictions from an Accessibility Perspective

**Analysis of macOS Standard Apps**:
- **General apps**: Sidebar + content area (**2 types**)
- **Development tools**: Toolbar + sidebar + content area (**3 types**)
- **Recommended Upper Limit**: **Maximum 3 types**

**Current Problem**: 7 types of background colors are too many, impairing visual unity and accessibility

#### Recommended Background Color Composition (3 types)

| Level | Purpose | Color Token | Integrated Targets |
|---|---|---|---|
| **Level 1: Main Background** | Basic content area | `base.background` | Base, panel, dialog, graph view |
| **Level 2: Navigation Background** | Sidebar area | `uiAreas.sideBar.background` | Primary sidebar, secondary sidebar, activity bar |
| **Level 3: System Background** | Window control area | `uiAreas.titleBar.background` | Title bar, status bar |

**Concept of 3-level background color system:**
- Level 1 (Main Background): Graph view, dialogs, panels
- Level 2 (Navigation Background): Primary sidebar, secondary sidebar, activity bar
- Level 3 (System Background): Title bar, status bar

#### Effects of Integration

**Improved Accessibility**:
- Reduced cognitive load (fewer color types)
- Clearer visual hierarchy
- Consideration for color vision deficiency

**Improved Design Quality**:
- Consistency with macOS standard apps
- Unified appearance
- Improved maintainability

#### Integration Policy during Preset Theme Design

**Background Color Integration Pattern:**
- **Level 1 (Main Background)**: Integrate 4 uses → base.background, panel.background, dialog.background, graph.background
- **Level 2 (Navigation Background)**: Integrate 3 uses → sideBar.background, secondarySideBar.background, activityBar.background
- **Level 3 (System Background)**: 1 use → titleBar.background

**Optimization of Color Values through Integration**:
- **Level 1**: `#1C1C1E`(Dark) / `#FFFFFF`(Light) - Most frequently used
- **Level 2**: `#2C2C2E`(Dark) / `#F2F2F7`(Light) - Dedicated for navigation
- **Level 3**: `#2D2D30`(Dark) / `#F3F3F3`(Light) - Dedicated for system control

### Button Color Integration

#### Primary Button
The background color of the primary button will be **the same as the primary color (currently the theme color)**.

#### Secondary Button
The secondary button will primarily have a **transparent background**, with color displayed only on hover.

### Border Color Integration

#### Basic Border Group
The following borders will use **the same color**:

| Purpose | Color Token | Reason for Integration |
|---|---|---|
| **Basic Border** | `base.border` | Standard separator line |
| **Divider** | `base.divider` | Separator between sections |
| **Panel Border** | `uiAreas.panel.border` | Outline of panels |
| **Dialog Border** | `uiAreas.dialog.border` | Outline of dialogs |

#### Dedicated Border Group
The following borders will use **dedicated colors**:

| Purpose | Color Token | Reason for Dedication |
|---|---|---|
| **Focus Border** | `interactive.input.focusBorder` | Clear identification of focus state |
| **Title Bar Border** | `uiAreas.titleBar.border` | Separation of window area |

### Icon Color Integration

#### Basic Principle
Icon colors will be used in two patterns depending on the **UI context**:

#### Icon Color When Not Selected
Uses **the same color as the basic text**.

#### Icon Color When Selected (2 Patterns)

**Pattern 1: Make icon color primary color**
- Background remains transparent or normal color
- Only icon is highlighted with primary color

**Pattern 2: Make background color primary color**
- Background set to primary color
- Icon color is white (ensures high contrast)

#### Guidelines for Usage

**When to use Pattern 1**:
- Tab navigation
- Toolbar icon buttons
- List item icons
- Display of minor selected states

**When to use Pattern 2**:
- Selected items in activity bar
- Important action states
- When strong visual emphasis is needed
- Expression of brand identity

### Text Color Integration

#### Basic Text Group
The following text colors will use **the same color**:

| Purpose | Color Token | Reason for Integration |
|---|---|---|
| **Basic Text** | `base.foreground` | Standard text color |
| **Panel Text** | `uiAreas.panel.foreground` | Text within panels |
| **Dialog Text** | `uiAreas.dialog.foreground` | Text within dialogs |
| **Button Text** | `interactive.button.text.normal` | Text of secondary buttons |

#### Dedicated Text Group
The following text colors will use **dedicated colors**:

| Purpose | Color Token | Reason for Dedication |
|---|---|---|
| **Primary Button Text** | `interactive.button.primaryText` | Ensures high contrast |
| **Selected Item Text** | `interactive.list.selectedText` | Clear identification of selected state |
| **Error Text** | `status.error` | Clear identification of status |

## 🎨 Theme Color Application Rules in Preset Themes

### Concept of Primary Color

**Preset Theme Design Philosophy**:
- **Preset Themes**: Use theme color as primary color
- **Custom Themes**: In the future, independent primary color settings not dependent on theme color
- **User Experience**: Primary color is not just aesthetics, but an important color that carries meaning in user experience

### Primary Color Usage Locations

The primary color (currently `theme.primaryColor`) will be **uniformly used** in the following locations:

#### Mandatory Application Locations
1. **Primary Button Background** - `interactive.button.primaryBackground`
2. **Selection State Display** - `base.selection`
3. **Focus Border** - `interactive.input.focusBorder`
4. **Active Item** - `uiAreas.activityBar.activeItem`
5. **Information Display** - `status.info`

#### Recommended Application Locations
1. **Graph Node Base Color** - `appSpecific.graph.nodeBase`
2. **Property Name Color** - `appSpecific.metadata.propertyName`
3. **Sidebar Group Header** - `uiAreas.sideBar.groupHeader`

### Prohibition of Primary Color Processing

**Reason**:
- Primary color holds special meaning in user experience
- To provide a consistent brand experience
- To ensure design integrity when supporting custom themes in the future

**Alternatives**:
- Hover effects: Predefine dedicated hover colors
- Selection states: Predefine dedicated selection background colors
- Disabled states: Predefine dedicated disabled colors

### Immutability of Primary Color

**Important Principle**: The primary color will be used **without any processing**.

**Processing to Avoid**:
- Applying transparency (`withAlpha`, `withOpacity`)
- Changing lightness (`lighten`, `darken`)
- Changing saturation (`saturate`, `desaturate`)

**Alternatives**: For hover effects, selection states, and disabled states, predefine dedicated colors.

### Alternative Implementation for Transparency

Instead of using transparency, predefine and use dedicated colors.

## 🔍 Preset Theme Design Checklist

### Check Items Before Adding New Colors (Only during preset theme design)

1. **Reusability of Existing Colors**
   - [ ] Check if there are existing colors for the same purpose
   - [ ] Check if similar semantic colors are defined
   - [ ] Check if there are color groups that can be integrated
   - [ ] Check if background colors fit within 3 types

2. **Necessity of Transparency**
   - [ ] Consider if it can be achieved without transparency
   - [ ] Consider if it can be replaced with a dedicated color definition
   - [ ] Check impact on accessibility

3. **Primary Color Processing**
   - [ ] Check if primary colors are not processed
   - [ ] If derived colors are needed, consider dedicated color definitions
   - [ ] Consider impact on user experience

3. **Semantic Meaning**
   - [ ] Is the meaning of the color clearly defined?
   - [ ] Are the relationships with other colors organized?
   - [ ] Is it appropriate for both light and dark modes?

### Check Items during Code Review

1. **Color Usage during Implementation**
   - [ ] Are `AppColorScheme` properties used?
   - [ ] Are there no hardcoded color values?
   - [ ] Is this guideline not referred to during implementation (should only be referred to during preset theme design)?

2. **Color Usage during Preset Theme Design**
   - [ ] Is transparency (`withAlpha`, `withOpacity`) not used?
   - [ ] Is primary color not processed (`lighten`, `darken`, etc.)?

3. **Compliance with Integration Rules during Preset Theme Design**
   - [ ] Does the background color follow the 3-level structure?
   - [ ] Do button colors follow the integration rules?
   - [ ] Do border colors follow the integration rules?
   - [ ] Is icon color usage appropriate (basic text color for unselected, 2 patterns for selected)?
   - [ ] Is it consistent with macOS standard apps?

4. **Primary Color Application during Preset Theme Design**
   - [ ] Is primary color used for primary actions?
   - [ ] Is primary color used for selection states?
   - [ ] Is primary color used for focus states?
   - [ ] Is primary color used without any processing?

## 📚 References

**Refer only during preset theme design:**
- [02. Design Tokens](./02-design-tokens.md) - Detailed color system specifications
- [05. Accessibility](./05-accessibility.md) - Contrast ratio and accessibility requirements

**Refer during implementation:**
- [03. Component Specifications](./03-components.md) - Implementation guidelines for each component
- `AppColorScheme` class documentation - How to use color scheme properties

### Rationale for Background Color Optimization

**macOS Human Interface Guidelines**:
- Background colors are used to express functional hierarchy
- Excessive number of colors increases cognitive load
- Consistency with system standard apps is important

**Accessibility Research**:
- Approximately 8% of colorblind individuals (men) have difficulty distinguishing multiple colors
- When the number of background colors is 3 or less, cognitive load is significantly reduced
- Hierarchy expression through lightness difference is most effective

---

**📍 Navigation**: [← Back](./08-master-detail-layout.md) | [Next: Table View Guidelines →](./10-table-view-guidelines.md)