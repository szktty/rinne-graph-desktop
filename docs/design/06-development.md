# 06. Development Tools

## 🎨 Catalog App

```bash
# View component list and tests
cd apps/catalog
flutter run
```

**Features:**
- Preview all components
- Interaction tests
- Accessibility verification
- Color palette display
- Spacing token verification

### How to Use the Catalog App

#### 1. Component Behavior Verification
- Visual confirmation of each component
- Testing interaction behavior
- Verification of display in different states

#### 2. Design Token Verification
- List display of color palettes
- Visualization of spacing tokens
- Verification of typography variants

#### 3. Accessibility Testing
- Verification of zoom functionality
- Keyboard navigation tests
- High contrast mode verification

## 🧪 Running Tests

### Basic Test Commands

```bash
# Run all tests
melos run test

# Test a specific package
cd packages/presentation/components
flutter test

# Tests with coverage
flutter test --coverage

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter test integration_test/
```

### Test Categories

#### 1. Unit Tests
```bash
# Logic tests
flutter test test/unit/

# Provider tests
flutter test test/providers/
```

#### 2. Widget Tests
```bash
# Component tests
flutter test test/widgets/

# Accessibility tests
flutter test test/accessibility/
```

#### 3. Integration Tests
```bash
# End-to-end tests
flutter test integration_test/app_test.dart

# Performance tests
flutter test integration_test/performance_test.dart
```

## 📊 Quality Checks

### Static Analysis

```bash
# Run static analysis
flutter analyze

# Analyze specific files
flutter analyze lib/src/widgets/app_button.dart

# Detailed analysis results
flutter analyze --verbose
```

### Code Formatting

```bash
# Run formatting
dart format .

# Format specific directories
dart format lib/

# Format check (for CI)
dart format --set-exit-if-changed .
```

### Dependency Management

```bash
# Check dependencies
flutter pub deps

# Display dependency tree
flutter pub deps --style=tree

# Check unused dependencies
flutter pub deps --unused
```

## 🔧 Development Support Tools

### Debugging Tools

```dart
// For debugging: Visualization of AppTextVariant
class DebugTypographyOverlay extends StatelessWidget {
  final Widget child;
  
  const DebugTypographyOverlay({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (kDebugMode)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 0.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
```

### Performance Optimization

```dart
// ✅ Recommended: Utilizing const constructors
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Use const to avoid rebuilds
        AppText('Fixed Text', variant: AppTextVariant.uiBody),
        SizedBox(height: 16),
      ],
    );
  }
}

// ✅ Recommended: Optimizing providers with select
Consumer(
  builder: (context, ref, child) {
    // Only watch necessary parts
    final backgroundColor = ref.watch(
      effectiveColorSchemeProvider.select((scheme) => scheme.surface),
    );
    
    return Container(color: backgroundColor, child: child);
  },
)
```

## 🚀 CI/CD Pipeline

### GitHub Actions Example Configuration

```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Check formatting
        run: dart format --set-exit-if-changed .
      
      - name: Analyze code
        run: flutter analyze
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

### Quality Gates

#### Mandatory Check Items
- [ ] All tests pass
- [ ] Code coverage 80% or higher
- [ ] No static analysis errors
- [ ] Format check passes
- [ ] Accessibility tests pass

#### Recommended Check Items
- [ ] Performance tests pass
- [ ] Security scans pass
- [ ] Dependency vulnerability checks pass

## 📈 Metrics Monitoring

### Performance Metrics

```dart
// Performance measurement example
class PerformanceMonitor {
  static void measureBuildTime(String widgetName, VoidCallback build) {
    final stopwatch = Stopwatch()..start();
    build();
    stopwatch.stop();
    
    if (kDebugMode) {
      print('$widgetName build time: ${stopwatch.elapsedMilliseconds}ms');
    }
  }
}

// Example usage
PerformanceMonitor.measureBuildTime('AppButton', () {
  return AppButton(label: 'Test', onPressed: () {});
});
```

### Memory Usage Monitoring

```dart
// Memory usage check
class MemoryMonitor {
  static void logMemoryUsage(String context) {
    if (kDebugMode) {
      final info = ProcessInfo.currentRss;
      print('$context - Memory usage: ${info ~/ 1024 ~/ 1024}MB');
    }
  }
}
```

## 🛠️ Development Environment Setup

### Required Tools

```bash
# Flutter SDK
flutter --version

# Dart SDK
dart --version

# Melos (Monorepo Management)
dart pub global activate melos

# Install dependencies
melos bootstrap
```

### VSCode Extensions

Recommended extensions:
- Flutter
- Dart
- Flutter Widget Snippets
- Bracket Pair Colorizer
- GitLens

### Configuration Files

**.vscode/settings.json**
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "dart.lineLength": 100
}
```

## 📚 Documentation Generation

### API Documentation

```bash
# Generate API documentation
dart doc

# Document specific packages
cd packages/presentation/components
dart doc
```

### Component Documentation

```dart
/// Common button component for RinneGraph
/// 
/// Optimized for desktop applications,
/// providing 32px height and accessibility support.
/// 
/// Example:
/// ```dart
/// AppButton(
///   label: 'Save',
///   onPressed: () => save(),
/// )
/// ```
class AppButton extends ConsumerWidget {
  // ...
}
```

---

**📍 Navigation**: [← Back](./05-accessibility.md) | [Back to Top](./README.md)