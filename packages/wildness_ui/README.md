# Wildness UI

![wildness UI banner](https://github.com/coolosos/wildness_ui/assets/3104968/e5b16892-b459-4f30-9c41-dd51dafcfe23)

A type-safe, component-driven design system framework for Flutter featuring **granular rebuilds**, **F-bounded polymorphism**, and seamless light/dark theme resolution.

---

## ✨ Features

- **Granular Rebuilds**: Uses `WildnessComponentProvider` under the hood so widgets only rebuild when their specific component theme changes.
- **F-Bounded Type Safety**: Strongly typed component contracts (`WildnessBase<T extends WildnessBase<T>>`) eliminating `dynamic` casts.
- **Theme Modes & Resolution**: Dynamic switching between Light and Dark themes with customizable `WildnessProperties`.
- **Local Overrides**: Override individual component themes anywhere in the widget subtree without affecting other components.
- **Dart 3 Native**: Built with modern class modifiers (`final class`, `abstract base class`) and collection patterns.

---

## 📦 Installation

Add `wildness_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  wildness_ui: ^2.0.0-rc.1
```

---

## 🚀 Getting Started

### 1. Define your Component Theme Data

Create a class extending `WildnessBase<T>`:

```dart
import 'package:flutter/material.dart';
import 'package:wildness_ui/wildness.dart';

base class ButtonThemeData extends WildnessBase<ButtonThemeData> {
  const ButtonThemeData({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius = 8.0,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;

  @override
  ButtonThemeData copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
  }) {
    return ButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ButtonThemeData lerp(ButtonThemeData? other, double t) {
    if (other == null) return this;
    return ButtonThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t)!,
      borderRadius: (borderRadius + (other.borderRadius - borderRadius) * t),
    );
  }

  @override
  List<Object?> get props => [backgroundColor, foregroundColor, borderRadius];
}
```

### 2. Define your Component Theme (InheritedTheme)

```dart
final class ButtonComponentTheme extends ComponentTheme<ButtonThemeData> {
  const ButtonComponentTheme({
    required super.data,
    required super.child,
    super.key,
  });

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ButtonComponentTheme(data: data, child: child);
  }

  static ButtonThemeData? of(BuildContext context) {
    return ComponentTheme.kindThemeData<ButtonThemeData>(context);
  }
}
```

### 3. Initialize `WildnessApp`

Wrap your application in `WildnessApp`:

```dart
import 'package:flutter/material.dart';
import 'package:wildness_ui/wildness.dart';

void main() {
  final properties = WildnessProperties(
    components: Configuration(
      light: [
        const ButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ],
      dark: [
        const ButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ],
    ),
  );

  runApp(
    WildnessApp(
      wildnessProperties: properties,
      child: const MyApp(),
    ),
  );
}
```

### 4. Consume the Theme in Widgets

```dart
class CoolButton extends StatelessWidget {
  const CoolButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ComponentTheme.kindThemeData<ButtonThemeData>(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme?.backgroundColor ?? Colors.grey,
        foregroundColor: theme?.foregroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme?.borderRadius ?? 4.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

### 5. Override a Component Locally

You can override a specific component anywhere in the tree with `WildnessComponentProvider`:

```dart
WildnessComponentProvider<ButtonThemeData>(
  data: const ButtonThemeData(
    backgroundColor: Colors.red,
    foregroundColor: Colors.yellow,
  ),
  child: const CoolButton(label: 'Special Action', onPressed: doSomething),
)
```

---

## ⚡ Granular Rebuilds

`WildnessApp` automatically registers a `WildnessComponentProvider` for each registered component in the theme. When a component's data changes, only widgets that depend on `ComponentTheme.kindThemeData<MyComponent>(context)` will rebuild, leaving the rest of the widget tree untouched.

---

## 📄 License

MIT © [Coolosos](https://github.com/coolosos)