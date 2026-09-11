# Wildness UI Example: Multi-Kind Design System

This example demonstrates the core power of `wildness_ui`: building a **100% pure Flutter design system (without Material dependencies)** with **multi-kind component variants** and automatic **Light/Dark mode token switching**.

## Key Concepts Demonstrated

### 1. Component Kinds (Variants)
In Wildness, you define a base component theme and specialize it into multiple strongly-typed **Kinds** (e.g., `ButtonThemeData` $\rightarrow$ `SecondaryButtonThemeData`, `DangerButtonThemeData`).

```dart
// Base Theme
base class ButtonThemeData extends WildnessBase<ButtonThemeData> { ... }

// Kinds (Variants)
final class SecondaryButtonThemeData extends ButtonThemeData { ... }
final class DangerButtonThemeData extends ButtonThemeData { ... }
```

### 2. Zero-Provider Consumption
`WildnessApp` automatically registers all component themes and kinds at the root. Widgets consume their tokens directly with `ComponentTheme.kindThemeData<T>(context)` without needing manual nested providers:

```dart
WildButton(label: 'Primary')
WildButton.secondary(label: 'Secondary')
WildButton.danger(label: 'Danger')
```

### 3. Light & Dark Mode Token Resolution
Tokens are defined in `Configuration` for both Light and Dark modes. Switching `forceThemeMode` updates all kinds across the app instantly.

## Running the Example

```bash
flutter run
```
