# Wildness UI Example

This example demonstrates how to build and consume custom, type-safe component themes using `wildness_ui`.

## Features Demonstrated

1. **Defining Custom Component Themes:** Implementing `WildnessBase<T>` and `ComponentTheme<T>`.
2. **Configuring `WildnessApp`:** Registering light and dark themes with `Configuration` and `WildnessProperties`.
3. **Consuming Themes:** Reading theme properties with `ComponentTheme.kindThemeData<T>(context)`.
4. **Local Theme Overrides:** Overriding a specific component theme for a subtree with `WildnessComponentProvider`.
5. **Theme Switching:** Switching between Light and Dark mode dynamically.

## Running the Example

```bash
flutter run
```
