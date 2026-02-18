# wildness_ui_golden_toolkit

A lightweight toolkit to simplify **Flutter Golden Tests** by organizing tests into **scenarios** and **device layouts** with minimal boilerplate.

It helps you focus on **what you want to render** instead of dealing with `pumpWidget`, surface sizing, and gesture setup.

---

## ✨ Features

- Define multiple **scenarios** for a component
- Render the same UI across **different devices**
- Automatic golden file naming and organization
- Built-in helpers for touch / hover interactions
- Handles surface size, DPR, and layout configuration
- Reduces golden test setup to a single function call

---

## 📦 Installation

Add to your `dev_dependencies`:

```yaml
dev_dependencies:
  wildness_ui_golden_toolkit: ^latest_version
```

---

## 🧪 Writing Your First Test

Wrap your components in Component definitions and choose how you want to render them.

---

## 📐 Column-Based Testing

Use testColumnComponent when you want to compare multiple scenarios vertically.


```dart
import 'package:flutter/material.dart';
import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('group_name', () {
    testColumnComponent(
      name: 'test_component_column',
      surfaceSize: const Size(800, 300),
      scenarios: [
        Component(
          name: 'test',
          widget: LinearProgressIndicator(
            value: 0.5,
            color: Color.fromRGBO(0, 0, 0, 1),
            backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          ),
        ),
      ],
    );
  });
}
```
---

## 📱 Device-Based Testing

Use testDeviceComponent to validate how a component behaves across multiple screen sizes.


```dart
import 'package:flutter/material.dart';
import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('group_name', () {
    testDeviceComponent(
      name: 'test_device_component',
      surfaceSize: const Size(800, 300),
      devices: [
        Device(name: 'iPhone 12', size: const Size(390, 844)),
        Device(name: 'iPad Pro', size: const Size(1024, 1366)),
      ],
      scenarios: [
        Component(
          name: 'test',
          widget: Column(
            children: [
              LinearProgressIndicator(
                value: 0.5,
                minHeight: 4.0,
                color: Color.fromRGBO(0, 0, 0, 1),
                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
              ),
            ],
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

---

### `Device`

Defines a virtual screen configuration.

| Property | Description |
|----------|-------------|
| `name`   | Label shown in the golden test |
| `size`   | Logical screen size |

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