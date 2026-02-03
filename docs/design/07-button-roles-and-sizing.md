# 07. Button Roles and Sizing

## 🎭 Button Role System (Apple HIG Compliant)

RinneGraph adopts a button role system compliant with **Apple Human Interface Guidelines**. Each role has specific uses and visual characteristics, promoting intuitive user understanding.

### 🔘 Available Button Roles

#### Normal Button
```dart
AppButton.normal(
  label: 'Edit',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: General operations without special meaning
- **Width**: auto (automatically adjusted according to content)
- **Color**: Default color (`buttonBackground`)
- **Padding**: 16px horizontal, 4px vertical

**Example Uses:** Edit, View, Details, Settings, Others

#### Primary Button
```dart
AppButton.primary(
  label: 'Save',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: Default button most likely to be selected by the user
- **Width**: 120px (fixed)
- **Color**: Theme color (`primaryColor`)
- **Padding**: 4px vertical (no horizontal padding)
- **Enter Key Support**: Automatically responds to Enter key in dialogs

**Example Uses:** Save, Send, Confirm, Next, Complete, Create

#### Cancel Button
```dart
AppButton.cancel(
  label: 'Cancel',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: Cancel the current action
- **Width**: 100px (fixed)
- **Color**: Default color (`buttonBackground`)
- **Padding**: 4px vertical (no horizontal padding)
- **Escape Key Support**: Automatically responds to Escape key in dialogs

**Example Uses:** Cancel, Close, Back

#### Destructive Button
```dart
AppButton.destructive(
  label: 'Delete',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: Operations that may lead to data destruction
- **Width**: 120px (fixed)
- **Color**: Error color (`statusError`)
- **Padding**: 4px vertical (no horizontal padding)
- **Warning Color**: Red-based to visually express danger

**Example Uses:** Delete, Discard, Reset, Clear

## 📐 Sizing Specifications

### 🎯 Size List by Role

| Role | Width | Height | Horizontal Padding | Vertical Padding | Purpose |
|---|---|---|---|---|---|
| **Normal** | auto | 32px | 16px | 4px | General operations |
| **Primary** | 120px | 32px | 0px | 4px | Important operations |
| **Cancel** | 100px | 32px | 0px | 4px | Cancel operations |
| **Destructive** | 120px | 32px | 0px | 4px | Destructive operations |

### 📏 Principles of Size Design

#### 1. **Desktop Optimization**
- **Minimum Height**: 32px (smaller than 44px for touch devices, optimized for desktop)
- **Mouse Operation**: Compact size adopted for precise operations

#### 2. **Japanese Text Support**
- **Minimum Width**: 100px (allows "キャンセル" (Cancel) 4 characters to be displayed comfortably)
- **Standard Width**: 120px (accommodates 6-8 character operation names)

#### 3. **Advantages of Fixed Width**
- **Visual Importance**: Wider buttons are perceived as more important operations
- **Layout Stability**: Stable placement in dialogs and forms
- **Consistency**: Buttons of the same role always have the same size

## 🎨 Color System

### 🌈 Color Specifications by Role

#### Normal & Cancel
```dart
// Background Color
backgroundColor: colorScope.background
borderColor: colorScope.border
textColor: colorScope.text

// Interaction
hoverColor: colorScope.hover
pressedColor: buttonBackgroundActive
```

#### Primary
```dart
// Background Color (using theme color)
backgroundColor: themeColorScheme.primaryColor
borderColor: themeColorScheme.primaryColor
textColor: Colors.white

// Interaction
hoverColor: themeColorScheme.hoverColor
pressedColor: themeColorScheme.pressedColor
```

#### Destructive
```dart
// Background Color (using dedicated destructive operation color)
backgroundColor:appColorScheme.interactive.button.destructiveBackground
borderColor:appColorScheme.interactive.button.destructiveBackground
textColor:appColorScheme.interactive.button.destructiveText

// Interaction
pressedColor:appColorScheme.interactive.button.destructivePressedBackground
```

### 🎭 Light / Dark Mode Support

All button roles automatically support light and dark modes:

**Light Mode:**
- Normal/Cancel: Light background, dark text
- Primary: Theme color background, white text
- Destructive: Red background, white text

**Dark Mode:**
- Normal/Cancel: Dark background, light text
- Primary: Theme color background, white text
- Destructive: Red background, white text

## 🎯 Usage Guidelines

### ✅ Recommended Usage Patterns

#### Use in Dialogs
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    AppButton.cancel(
      label: 'Cancel',
      onPressed: () => Navigator.pop(context),
    ),
    const SizedBox(width: 16),
    AppButton.primary(
      label: 'Save',
      onPressed: _save,
    ),
  ],
)
```

#### Delete Confirmation Dialog
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    AppButton.cancel(
      label: 'Cancel',
      onPressed: () => Navigator.pop(context),
    ),
    const SizedBox(width: 16),
    AppButton.destructive(
      label: 'Delete',
      onPressed: _delete,
    ),
  ],
)
```

#### Use in Forms
```dart
Column(
  children: [
    // Form content...
    
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton.normal(
          label: 'Reset',
          onPressed: _reset,
        ),
        const SizedBox(width: 16),
        AppButton.primary(
          label: 'Submit',
          onPressed: _submit,
        ),
      ],
    ),
  ],
)
```

### ❌ Patterns to Avoid

#### 1. **Misuse of Primary Role**
```dart
// ❌ Bad example: Using Primary for destructive operations
AppButton.primary(
  label: 'Delete', // Should use Destructive for destructive operations
  onPressed: _delete,
)

// ✅ Good example
AppButton.destructive(
  label: 'Delete',
  onPressed: _delete,
)
```

#### 2. **Multiple Primary Buttons**
```dart
// ❌ Bad example: Multiple Primary buttons
Row(
  children: [
    AppButton.primary(label: 'Save', onPressed: _save),
    AppButton.primary(label: 'Send', onPressed: _submit), // Confusing
  ],
)

// ✅ Good example: One Primary + Normal
Row(
  children: [
    AppButton.normal(label: 'Save Draft', onPressed: _save),
    AppButton.primary(label: 'Send', onPressed: _submit),
  ],
)
```

### 🔄 Role Selection Flowchart

```
What is the nature of the operation?
├─ Destroys data → Destructive
├─ Most important/recommended → Primary
├─ Cancel/Close → Cancel
└─ Other general operations → Normal
```

## 🚀 Best Practices for Implementation

### 1. **Maintaining Accessibility**
```dart
// ✅ Do not disable zoom functionality
AppButton.primary(
  label: 'Save',
  onPressed: _save,
  // disableZoom: false is automatically applied
)
```

### 2. **Appropriate Spacing**
```dart
// ✅ Appropriate spacing between buttons
const SizedBox(width: 16), // AppSpacing.lg
```

### 3. **Consistent Layout**
```dart
// ✅ Right-aligned with Cancel → Primary order
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    AppButton.cancel(...),
    const SizedBox(width: 16),
    AppButton.primary(...),
  ],
)
```

By following these guidelines, we can provide a button UI that is intuitive and consistent for users.

---

**📍 Navigation**: [← Back](./06-development.md) | [Next: MasterDetailLayout Design Specification →](./08-master-detail-layout.md)