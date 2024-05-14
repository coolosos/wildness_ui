part of 'elementary.dart';

@immutable
class ElementaryProperties {
  /// Creates a [ElementaryProperties] tha's used to configure ElementaryUI
  ///
  /// The [forzeThemeElementaryMode] will be used to set the theme,
  /// if you dont pass it, the system default setting is used
  /// fallback is light
  const ElementaryProperties({
    Brightness? forzeThemeMode,
    ThemeComponents components = const ThemeComponents(),
    this.physics = const ClampingScrollPhysics(),
    this.minScaleFactor = 0.5,
    this.maxScaleFactor = 1.2,
  })  : _forzeThemeMode = forzeThemeMode,
        _components = components;

  /// Componets of this theme.
  ///
  /// To define components, pass an [Iterable] containing one or more [ElementaryBase] and their kinds
  final ThemeComponents _components;

  /// By default uses a system config
  /// if you pass a mode, it will be forced to this one.
  final Brightness? _forzeThemeMode;

  /// The default Scroll physics for this theme.
  final ScrollPhysics physics;

  final double minScaleFactor;
  final double maxScaleFactor;

  Map<Type, ElementaryBase<dynamic>> componentsIterableToMap(
    BuildContext? context,
  ) {
    final Iterable<ElementaryBase<dynamic>> components =
        resolve<Iterable<ElementaryBase<dynamic>>>(
      context,
      light: _components.light,
      dark: _components.dark,
    ).toSet();

    return Map<Type, ElementaryBase<dynamic>>.unmodifiable(
      {
        for (final ElementaryBase<dynamic> component in components)
          component.runtimeType: component,
      },
    );
  }

  T resolve<T>(
    BuildContext? context, {
    required T light,
    required T dark,
  }) =>
      _themeMode(context).resolve<T>(
        light: light,
        dark: dark,
      );

  Brightness _themeMode(
    BuildContext? context,
  ) =>
      _forzeThemeMode ??
      context?.resolve(
        light: Brightness.light,
        dark: Brightness.dark,
      ) ??
      Brightness.light;

  /// Convert the [componentsIterable] passed to [ElementaryThemeData.new] or [copyWith]
  /// to the stored [components] map, where each entry's key consists of the extension's type.
}

extension _BrightnessX on Brightness {
  /// Resolves the given colors based on the current brightness.
  T resolve<T>({
    required T light,
    required T dark,
  }) {
    switch (this) {
      case Brightness.light:
        return light;
      case Brightness.dark:
        return dark;
    }
  }
}

extension _DarkThemeX on BuildContext {
  T resolve<T>({
    required T light,
    required T dark,
  }) {
    return MediaQuery.platformBrightnessOf(this).resolve(
      light: light,
      dark: dark,
    );
  }
}
