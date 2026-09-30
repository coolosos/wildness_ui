# Wildness UI Golden Toolkit 📸

<p align="center">
  <strong>A lightweight, zero-boilerplate toolkit to streamline Flutter Golden Tests across multi-device viewports and visual scenario matrixes.</strong>
</p>

<p align="center">
  <a href="https://pub.dev/packages/wildness_ui_golden_toolkit"><img src="https://img.shields.io/pub/v/wildness_ui_golden_toolkit.svg?label=pub&color=purple" alt="Pub Version"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%3E%3D3.47.2-02569B?logo=flutter" alt="Flutter Version"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-%3E%3D3.13.2-0175C2?logo=dart" alt="Dart Version"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

---

## ✨ Features

- 📱 **Multi-Device Testing**: Render components across realistic device dimensions with `Devices.all`, `Devices.phones`, and `Devices.tablets`.
- 📐 **Scenario Columns**: Stack multiple variants (hover, active, disabled, loading) vertically with `testColumnComponent`.
- 🤖 **Zero-Boilerplate**: Handles font loading, DPR, surface sizes, and gesture simulation automatically.
- 🎨 **Wildness UI Native**: Seamlessly injects `WildnessApp.withDefaultTheme` and component providers.
- ⚡ **Lightweight & Fast**: Pure Flutter test harness with zero heavy external dependencies.

---

## 📦 Installation

Add to your `dev_dependencies`:

```yaml
dev_dependencies:
  wildness_ui_golden_toolkit: ^2.0.0
```

---

## 🧪 Writing Your First Test

Wrap your components in `Component` definitions and choose how you want to render them.

---

## 📐 Column-Based Testing

Use `testColumnComponent` when you want to compare multiple scenarios vertically.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('WildButton Scenarios', () {
    testColumnComponent(
      name: 'wild_button_scenarios',
      surfaceSize: const Size(800, 400),
      scenarios: [
        Component(
          name: 'primary_default',
          widget: WildButton<PrimaryButtonThemeData>(
            label: 'Primary Button',
            onTap: () {},
          ),
        ),
        Component(
          name: 'secondary_outline',
          widget: WildButton<SecondaryButtonThemeData>(
            label: 'Secondary Button',
            onTap: () {},
          ),
        ),
      ],
    );
  });
}
```

---

## 📱 Device-Based Testing

Use `testDeviceComponent` to validate how a component behaves across multiple screen sizes.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('WildButton Responsive', () {
    testDeviceComponent(
      name: 'wild_button_devices',
      devices: Devices.phones,
      scenarios: [
        Component(
          name: 'primary_action',
          widget: WildButton<PrimaryButtonThemeData>(
            label: 'Confirm Transaction',
            onTap: () {},
          ),
        ),
      ],
    );
  });
}
```

---

## 🧩 Core Concepts

### `Component`

Represents a single UI state you want to validate.

| Property | Description |
|----------|-------------|
| `name`   | Identifier used in the golden output |
| `widget` | The widget to render |
| `textScaleFactor` | Optional text scale override |

---

### `TestDevice` and `Devices`

Defines a virtual screen configuration. Use predefined devices from `Devices.all`, `Devices.phones`, `Devices.tablets`, or create custom `TestDevice` instances.

| Property | Description |
|----------|-------------|
| `name`   | Label shown in the golden test |
| `size`   | Logical screen size |
| `devicePixelRatio` | Device pixel ratio (default: 1.0) |
| `safeArea` | Safe area insets (default: EdgeInsets.zero) |

---

### `testColumnComponent`

Best for:

- Visual regression of variants  
- Comparing states (enabled, disabled, loading, etc.)  
- Reviewing multiple scenarios stacked vertically  

---

### `testDeviceComponent`

Best for:

- Responsive validation  
- Catching layout issues early  
- Design-system certification across breakpoints  

---

## 📂 Golden Output

Golden files are generated automatically and can be reviewed using:

```bash
flutter test --update-goldens
```

---

## 🎯 Ideal Use Cases

- Design systems  
- Component libraries  
- CI visual regression testing  
- Multi-device UI validation  
- Preventing layout regressions  

---

## 🤝 Contributing

Contributions, issues, and suggestions are welcome!

---

## 📄 License

MIT © 2026 [Coolosos](https://github.com/coolosos)