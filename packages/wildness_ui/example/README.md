# Wildness UI Example: Multi-Kind Component

This example demonstrates how to build a **100% pure Flutter component with multiple kinds (variants)** using `wildness_ui` with zero Material dependencies.

## Key Concepts Demonstrated

### 1. Base Theme with Reusable `copyWith` and `lerp`
The base class `ButtonThemeData<T>` defines all properties, `copyWith`, and `lerp` once using F-bounded polymorphism and a `create` factory method. Concrete kinds do not need to duplicate them:

```dart
abstract base class ButtonThemeData<T extends ButtonThemeData<T>> extends WildnessBase<T> {
  const new({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  /// Subclasses only implement create to instantiate their concrete kind.
  T create({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderRadius,
    EdgeInsetsGeometry padding,
  });

  @override
  T copyWith({ ... }) => create( ... );

  @override
  T lerp(WildnessBase<T>? other, double t) { ... }
}
```

### 2. Concrete Kinds (Variants)
Each kind simply extends the base theme:

```dart
final class PrimaryButtonThemeData extends ButtonThemeData<PrimaryButtonThemeData> { ... }
final class SecondaryButtonThemeData extends ButtonThemeData<SecondaryButtonThemeData> { ... }
```

### 3. One Component, Multiple Kinds
The same widget (`WildButton`) renders different variants depending on the `kind` parameter using `ComponentTheme.kindThemeData<T>(context)`:

```dart
// Primary Kind
WildButton(
  label: 'Primary Button',
  kind: ButtonKind.primary,
  onTap: () {},
)

// Secondary Kind
WildButton(
  label: 'Secondary Button',
  kind: ButtonKind.secondary,
  onTap: () {},
)
```

### 4. Global Configuration and Light/Dark Mode
All kinds are registered in `WildnessProperties` and resolved automatically for Light and Dark modes without boilerplate:

```dart
WildnessProperties(
  forceThemeMode: brightness,
  components: const Configuration(
    light: [lightPrimary, lightSecondary],
    dark: [darkPrimary, darkSecondary],
  ),
);
```

## Running the Example

```bash
flutter run
```
