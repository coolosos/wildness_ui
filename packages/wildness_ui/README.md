# Wildness UI 🌿

<p align="center">
  <img src="https://github.com/coolosos/wildness_ui/assets/3104968/e5b16892-b459-4f30-9c41-dd51dafcfe23" alt="Wildness UI Banner" width="100%" />
</p>

<p align="center">
  <strong>A type-safe, component-driven design system framework for Flutter featuring granular rebuilds, F-bounded polymorphism, and seamless light/dark theme resolution.</strong>
</p>

<p align="center">
  <a href="https://pub.dev/packages/wildness_ui"><img src="https://img.shields.io/pub/v/wildness_ui.svg?label=pub&color=blue" alt="Pub Version"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%3E%3D3.47.2-02569B?logo=flutter" alt="Flutter Version"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-%3E%3D3.13.2-0175C2?logo=dart" alt="Dart Version"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

---

## ✨ Features

- ⚡ **Granular Rebuilds**: Uses `InheritedModel<Type>` aspect subscriptions so widgets only rebuild when their specific component theme updates.
- 🛡️ **F-Bounded Type Safety**: Strongly typed component contracts (`WildnessBase<T extends WildnessBase<T>>`) eliminating `dynamic` casts.
- 🎨 **Multi-Kind (Variant) Architecture**: Easily parameterize components into variants (Primary, Secondary, Outline, Ghost) with zero duplicated boilerplate.
- 🌓 **Theme Modes & Resolution**: Dynamic switching between Light and Dark themes with customizable `WildnessProperties`.
- 📍 **Local Scoped Overrides**: Override individual component themes anywhere in the widget subtree without side effects.
- 🔍 **Dynamic Component Lookup**: Search components dynamically by name (`componentByName`) or strongly-typed cast (`componentByNameCast`).
- 🎯 **Dart 3 Native**: Built with modern class modifiers (`final class`, `abstract base class`) and pattern matching.

---

## 📦 Installation

Add `wildness_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  wildness_ui: ^2.0.0
```

---

## 🚀 Step-by-Step Guide

### 1. Define Theme Data with Polymorphic Kinds

Create an abstract base theme class to share styling properties and logic across variants:

```dart
import 'package:flutter/widgets.dart';
import 'package:wildness_ui/wildness.dart';

/// Base contract for Button themes
abstract base class ButtonThemeData<T extends ButtonThemeData<T>>
    extends WildnessBase<T> {
  const new({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  /// Concrete subclasses instantiate their kind
  T create({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderRadius,
    EdgeInsetsGeometry padding,
  });

  @override
  T copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return create(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  T lerp(WildnessBase<T>? other, double t) {
    if (other is! ButtonThemeData<T>) return this as T;
    return create(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ?? backgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius: borderRadius + (other.borderRadius - borderRadius) * t,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
    );
  }

  @override
  List<Object?> get props => [backgroundColor, textColor, borderColor, borderRadius, padding];
}

/// Primary button variant
final class PrimaryButtonThemeData extends ButtonThemeData<PrimaryButtonThemeData> {
  const new({
    required super.backgroundColor,
    required super.textColor,
    super.borderColor,
    super.borderRadius,
    super.padding,
  });

  @override
  PrimaryButtonThemeData create({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderRadius = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  }) {
    return PrimaryButtonThemeData(
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}

/// Secondary button variant
final class SecondaryButtonThemeData extends ButtonThemeData<SecondaryButtonThemeData> {
  const new({
    required super.backgroundColor,
    required super.textColor,
    super.borderColor,
    super.borderRadius,
    super.padding,
  });

  @override
  SecondaryButtonThemeData create({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderRadius = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  }) {
    return SecondaryButtonThemeData(
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}
```

---

### 2. Build a Pure Flutter Component Widget

Create your design system widget parameterized by theme kind `K`:

```dart
class WildButton<K extends ButtonThemeData<K>> extends StatelessWidget {
  const new({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Aspect subscription: rebuilds only when kind K changes
    final theme = ComponentTheme.kindThemeData<K>(context);

    final backgroundColor = theme?.backgroundColor ?? const Color(0xFF1E293B);
    final textColor = theme?.textColor ?? const Color(0xFFFFFFFF);
    final borderColor = theme?.borderColor;
    final borderRadius = theme?.borderRadius ?? 8.0;
    final padding = theme?.padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
```

---

### 3. Initialize `WildnessApp`

```dart
import 'package:flutter/widgets.dart';
import 'package:wildness_ui/wildness.dart';

void main() {
  final properties = WildnessProperties(
    components: const Configuration(
      light: [
        PrimaryButtonThemeData(
          backgroundColor: Color(0xFF2563EB),
          textColor: Color(0xFFFFFFFF),
        ),
        SecondaryButtonThemeData(
          backgroundColor: Color(0x00000000),
          textColor: Color(0xFF2563EB),
          borderColor: Color(0xFF2563EB),
        ),
      ],
      dark: [
        PrimaryButtonThemeData(
          backgroundColor: Color(0xFF3B82F6),
          textColor: Color(0xFFFFFFFF),
        ),
        SecondaryButtonThemeData(
          backgroundColor: Color(0x00000000),
          textColor: Color(0xFF93C5FD),
          borderColor: Color(0xFF3B82F6),
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

---

### 4. Local Scoped Overrides

Override any component theme locally for a specific subtree:

```dart
WildnessComponentProvider<PrimaryButtonThemeData>(
  data: const PrimaryButtonThemeData(
    backgroundColor: Color(0xFFDC2626),
    textColor: Color(0xFFFFFFFF),
  ),
  child: WildButton<PrimaryButtonThemeData>(
    label: 'Destructive Action',
    onTap: () {},
  ),
)
```

---

### 5. Dynamic Token Resolution

Query components dynamically at runtime (e.g. for Server-Driven UI):

```dart
// Dynamic lookup by name
final component = ComponentTheme.componentByName('PrimaryButtonThemeData', context);

// Type-safe casted lookup
final buttonTheme = ComponentTheme.componentByNameCast<PrimaryButtonThemeData>('PrimaryButtonThemeData', context);
```

---

## ⚡ How Granular Rebuilds Work

When a component theme data changes inside `WildnessProperties`, `WildnessProvider` uses Flutter's native `InheritedModel.inheritFrom(context, aspect: T)` under the hood. Only widgets listening to that specific type `T` will re-render, leaving every other widget untouched for maximum UI performance.

---

## 📄 License

MIT © [Coolosos](https://github.com/coolosos)