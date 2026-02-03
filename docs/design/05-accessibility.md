# 05. Accessibility

## 🎯 Accessibility Strategy

RinneGraph aims to be **WCAG 2.1 AA compliant**, striving to be an application that all users can comfortably use.

**Compliance Level:**
- ✅ **Level A**: Basic Accessibility (Implemented)
- ✅ **Level AA**: Advanced Accessibility (In Progress)
- 🔄 **Level AAA**: Highest Level (Future Support)

## 🔍 Zoom / Magnification Function

### AppAccessibilityConfig

**Configuration Items:**
```dart
class AppAccessibilityConfig {
  final double zoomScale;        // 1.0 - 2.0 (100% - 200%)
  final double borderScale;      // 1.0 - 1.5 (Border Magnification)
  final double fontScale;        // 1.0 - 2.0 (Font Magnification)
  final bool highContrastMode;   // High Contrast Mode
}
```

### Implementation Pattern

```dart
// Applied uniformly across all components
class AppButton extends ConsumerWidget {
  final bool disableZoom;  // Individual disable
  
  const AppButton({super.key, required this.label, this.onPressed, this.disableZoom = false});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(accessibilityConfigProvider);
    final scale = disableZoom ? 1.0 : config.zoomScale;
    
    return Container(
      height: 32.0 * scale,  // Desktop optimized
      padding: EdgeInsets.symmetric(
        horizontal: 16.0 * scale,
        vertical: 6.0 * scale,
      ),
      // ...
    );
  }
}
```

## ⌨️ Keyboard Navigation

### Basic Operations

| Key | Action | Implementation Status |
|---|---|---|
| **Tab** | Focus to next element | ✅ Implemented |
| **Shift+Tab** | Focus to previous element | ✅ Implemented |
| **Enter/Space** | Execute action | ✅ Implemented |
| **Escape** | Close dialog/menu | ✅ Implemented |
| **Arrow Keys** | Navigate within list | 🔄 In Progress |

### Shortcut Keys

**Global Shortcuts:**
```dart
// Example of Command Palette implementation
Shortcuts(
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK): 
        const OpenCommandPaletteIntent(),
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyB): 
        const ToggleSidebarIntent(),
  },
  child: Actions(
    actions: {
      OpenCommandPaletteIntent: OpenCommandPaletteAction(ref),
      ToggleSidebarIntent: ToggleSidebarAction(ref),
    },
    child: child,
  ),
)
```

### Focus Management

**Focus Scope:**
```dart
// Focus trap in dialogs
FocusScope(
  autofocus: true,
  child: AppDialog(
    child: Column(
      children: [
        AppTextField(...),  // Automatic focus
        AppButton(...),
      ],
    ),
  ),
)
```

## 🔊 Screen Reader Support

### Semantics Widget

```dart
// ✅ Recommended: Appropriate semantic information
Semantics(
  button: true,
  label: 'Save File',
  hint: 'You can also save with Cmd+S',
  enabled: true,
  child: AppButton(
    label: 'Save',
    onPressed: _save,
  ),
)

// ✅ Recommended: Semantic for list items
Semantics(
  customSemanticsActions: {
    CustomSemanticsAction(label: 'Edit'): _edit,
    CustomSemanticsAction(label: 'Delete'): _delete,
  },
  child: ListTile(...),
)
```

### Live Regions

```dart
// ✅ Recommended: Notification of dynamic content
Semantics(
  liveRegion: true,
  child: Text(statusMessage),
)

// ✅ Recommended: Notification of error messages
Semantics(
  liveRegion: true,
  child: Text(
    errorMessage,
    style: TextStyle(color: Colors.red),
  ),
)
```

## 🎨 High Contrast Support

### Color Contrast Ratio

**WCAG AA Compliant:**
- **Normal Text**: 4.5:1 or higher
- **Large Text**: 3:1 or higher
- **UI Elements**: 3:1 or higher

```dart
// ✅ Recommended: Color selection considering contrast ratio
final textColor = appColorScheme.foreground;      // 4.5:1
final backgroundColor = appColorScheme.surface;   // Appropriate contrast
final accentColor = appColorScheme.accentColor;   // 3:1 or higher
```

### High Contrast Mode

```dart
// High contrast mode support
Consumer(
  builder: (context, ref, child) {
    final config = ref.watch(accessibilityConfigProvider);
    final colors = config.highContrastMode 
        ?appColorScheme.highContrast 
        :appColorScheme.normal;
    
    return Container(
      color: colors.surface,
      child: Text(
        'Text',
        style: TextStyle(color: colors.onSurface),
      ),
    );
  },
)
```

## 🧪 Accessibility Testing

### Automated Tests

```dart
// Semantic test
testWidgets('Button accessibility test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  // Verify semantic information
  expect(
    tester.getSemantics(find.byType(AppButton)),
    matchesSemantics(
      label: 'Test Button',
      isButton: true,
      isEnabled: true,
      hasTapAction: true,
    ),
  );
});

// Zoom functionality test
testWidgets('Zoom functionality test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  // Change zoom setting
  final container = ProviderContainer();
  container.read(accessibilityConfigProvider.notifier).setZoomScale(1.5);
  
  await tester.pumpAndSettle();
  
  // Verify size change
  final button = tester.widget<Container>(find.byType(Container));
  expect(button.constraints?.minHeight, equals(32.0 * 1.5));
});
```

### Manual Test Items

- [ ] Operate all functions with keyboard only
- [ ] Get information with screen reader
- [ ] Check display at 200% zoom
- [ ] Visibility in high contrast mode
- [ ] Check with color blind simulation

## 🚫 Animation Prohibition Policy

### 🎯 Basic Policy

RinneGraph **prohibits all animations**. This achieves the following:

- **Performance Improvement**: Reduced CPU/GPU load
- **Usability Improvement**: Reduced visual noise
- **Accessibility Support**: Consideration for users sensitive to motion
- **Increased Focus**: Prevents distraction from unnecessary visual movement

### ✅ Permitted Exceptions

The following animations are exceptionally permitted for **important status display and UI operability improvement for the user**:

- **Progress Bar**: Visual display of loading progress (`LinearProgressIndicator`, `CircularProgressIndicator`)
- **Loading Spinner**: Animation indicating processing (but minimal)
- **Popovers**: Display/hide animations for menus and tooltips (`AppPopover`, `Tooltip`, etc.)
- **Dialogs**: Display/hide animations for modal dialogs (`AppDialog`, `showDialog`, etc.)

### 🚨 Mandatory Disable Animations

The following animations **must be disabled**:

```dart
// ✅ Required: Disable SegmentedButton animation
SegmentedButton.styleFrom(
  animationDuration: Duration.zero,      // Disable animation on selection
  splashFactory: NoSplash.splashFactory, // Disable ripple animation
)

// ✅ Required: Disable ExpansionTile animation
ExpansionTile(
  tilePadding: EdgeInsets.zero,
  childrenPadding: EdgeInsets.zero,
  // Disable animation-related parameters
)

// ✅ Required: Disable PageView animation
PageController(
  // Set animation duration to 0 if necessary
)
```

## 📋 Accessibility Checklist

### 🔍 Check Items during Implementation

- [ ] **Zoom Support**: Normal display at 100%-200%
- [ ] **Keyboard Operation**: Navigable with Tab/Shift+Tab
- [ ] **Semantic Information**: Set appropriate label, hint, role
- [ ] **Focus Management**: Visual focus indicator
- [ ] **Contrast Ratio**: WCAG AA compliant (4.5:1 or higher)
- [ ] **Tap Target**: Minimum 44px (32px on desktop)
- [ ] **Error Handling**: Clear error messages
- [ ] **Animation**: Disable unnecessary animations

### 🧪 Test Items

- [ ] **Automated Tests**: Verification of semantic information
- [ ] **Manual Tests**: Operation with keyboard only
- [ ] **Screen Reader**: Verification with VoiceOver/TalkBack
- [ ] **Zoom Test**: Check display at 200% magnification
- [ ] **Color Vision Test**: Check with color blind simulation

---

**📍 Navigation**: [← Back](./04-implementation.md) | [Next: Development Tools →](./06-development.md)