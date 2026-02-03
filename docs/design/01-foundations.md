# 01. Basic Concepts and Principles

## 🎨 Design Principles

### 🏛️ Core Philosophy

**1. Consistency**
- Unified design language across all components
- Centralized management through design tokens
- Predictable user experience

**2. Accessibility**
- WCAG 2.1 AA compliant
- Full keyboard navigation support
- Screen reader support
- Zoom functionality (100%-200%)

**3. Platform Integration**
- Harmony with macOS native UI
- Automatic reflection of system settings (dark mode, etc.)
- Integration with native accessibility APIs

**4. Customizability**
- Flexible styling through theme system
- Personalization via user settings
- Extensible component architecture

**5. Performance**
- Efficient widget tree
- Minimal rebuilds
- Responsive user interaction

**6. No Animation**
- **All animations are disabled** (except for progress bars, popovers, dialogs, etc.)
- Improved usability and performance optimization
- Reduced visual noise

### 🖥️ Desktop-First Design

**Target**: Desktop applications (macOS, Windows, Linux)
- **Operation Method**: Optimized for mouse and keyboard operation
- **Size Standard**: 32px standard for desktop, not 44px for mobile
- **Information Density**: Efficient use of vertical space
- **Precise Operation**: Supports precise operation with mouse cursor

## 🏗️ Design System Architecture

### 📦 Package Structure

```
packages/
├── core/
│   └── themes/           # Theme/Design Token Management
└── presentation/
    └── components/       # UI Component Library
```

### 🔄 Data Flow

```
User Settings → AppThemeData →appColorScheme → Components
           ↘ AccessibilityConfig → Zoom/Focus Control
```

### 🎛️ State Management

- **Riverpod**: Provider-based state management
- **Theme Switching**: Reactive theme changes
- **Setting Persistence**: Setting storage using SharedPreferences

## 🎯 Design Token Overview

### 💡 What are Design Tokens?

Design tokens are a mechanism for defining and centrally managing the **atomic values** (colors, sizes, spacing, etc.) of a design system. This achieves the following:

- **Consistency**: Use of unified values across all components
- **Maintainability**: Minimizing the scope of impact when changes are made
- **Extensibility**: Providing a basis for creating new components

### 🏗️ 3-Layer Architecture

```
┌─ Primitive Tokens ──────────────────┐
│ Definition of basic values         │
│ (gray-500, spacing-16, font-medium)│
└───────────────↓─────────────────────┘
┌─ Semantic Tokens ───────────────────┐
│ Role-based semantic definitions    │
│ (primary, surface, content-padding)│
└───────────────↓─────────────────────┘
┌─ Component Tokens ──────────────────┐
│ Adjustment values for specific    │
│ components (button-padding,       │
│ card-border-radius)               │
└─────────────────────────────────────┘
```

### 🔗 Relationship with Implementation

In the current RinneGraph, the following implementations form the basis of design tokens:

- **AppColorScheme**: 60+ detailed color definitions
- **AppTextVariant**: 20 text styles
- **AppAccessibilityConfig**: Zoom/scaling settings
- Constant definitions for each component (to be integrated in the future)

## 📐 4px Grid System

RinneGraph adopts a **4-pixel based grid system**, where all margins and sizes are multiples of this unit. This achieves a visually harmonious layout.

### 🖥️ Desktop Optimization

- **Efficient Space Usage**: 32px base instead of 44px for mobile
- **Mouse Operation Support**: Sizes suitable for precise cursor operation
- **Improved Information Density**: Efficient use of vertical space

### Benefits

- Visual unity
- Consistency across different resolutions
- Improved communication efficiency between designers and developers
- Affinity with zoom functionality

---

**📍 Navigation**: [← Back](./README.md) | [Next: Design Tokens →](./02-design-tokens.md)