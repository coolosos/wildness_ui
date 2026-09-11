## 2.0.0-rc.2

- **Chore**: Updated dependency `wildness_ui` to `^2.0.0-rc.2`.

## 2.0.0-rc.1

- **Feat**: Added `const` constructor and `@immutable` to `Component` for compile-time test scenario allocation.
- **Modernization**: Converted `Devices` to `abstract final class Devices` and `TestDevice` / `GoldenRenderConfig` to `final class`.
- **Modernization**: Refactored `FontLoader` with Dart 3 pattern matching (`whereType` & `case`), eliminating dynamic casts.
- **Chore**: Updated dependency `wildness_ui` to `^2.0.0-rc.1`.
- **Chore**: Removed unused dependencies (`equatable`, `nested`, `build_runner`).
- **Chore**: Updated `coolint` to `^3.0.0-rc.1`.
- **Chore**: Upgraded SDK environment to Flutter `>=3.47.2` and Dart `>=3.13.2`.

## 1.1.0
- update to flutter 3.47.2
- update packages to last version
- remove material_ui dependency

## 1.0.3
- **Fix**: wrap is only applied to child in test column component

## 1.0.2
- **Fix**: Golden test failures are now properly reported in the console.

## 1.0.1
- Change gesture keys to better reflect what they do
- You can now configure the axis of the images generated on devices

## 1.0.0
- Stable release.
- Improved touch gesture simulation support in component tests.
- Prepared package for public release on pub.dev.
- **Major Refactoring:** Migrated from the deprecated `golden_toolkit` dependency to an internal, custom golden test solution. This change significantly updates the underlying golden testing infrastructure.

## 0.1.7
- Updated dependencies to ensure compatibility with `wildness_ui` version 1.1.0.
- General project formatting.

## 0.1.6
- Updated dependencies to ensure compatibility with `wildness_ui` version 1.0.0.

## 0.1.5
- Fix spells in the golden toolkit.
- Updated dependencies to ensure compatibility with `wildness_ui` version 0.1.2.
- Remove `flutter_localizations` dependency

## 0.1.4
- Fix spells.

## 0.1.3
- Added more properties for component tests.
- Passthrough `WidgetTester` for gestures.

## 0.1.2
- Added wrap for scenarios.
- Use `home` on `widgetApp`.

## 0.1.1
Changes on `testColumnComponent` and `testDeviceComponent`:
- Removed `gestureBuilder` parameter as required.
- Added `groupName` parameter.

## 0.1.0
- First version.
