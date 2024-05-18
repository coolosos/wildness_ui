part of '../elementary.dart';

@immutable
class ElementaryProperties {
  /// Creates a [ElementaryProperties] tha's used to configure ElementaryUI
  ///
  /// The [forzeThemeElementaryMode] will be used to set the theme,
  /// if you dont pass it, the system default setting is used
  /// fallback is light
  const ElementaryProperties({
    this.forzeThemeMode,
    Configuration components = const Configuration(),
    Configuration fundations = const Configuration(),
    this.physics = const ClampingScrollPhysics(),
    this.minScaleFactor = 0.5,
    this.maxScaleFactor = 1.2,
  })  : _fundations = fundations,
        _components = components;

  /// Componets of this theme.
  ///
  /// To define components, pass an [Iterable] containing one or more [ElementaryBase] and their kinds
  final Configuration _components;
  final Configuration _fundations;

  /// By default uses a system config
  /// if you pass a mode, it will be forced to this one.
  final Brightness? forzeThemeMode;

  /// The default Scroll physics for this theme.
  final ScrollPhysics physics;

  final double minScaleFactor;
  final double maxScaleFactor;

  /// Convert the [_components] passed to [ElementaryProperties.new]
  /// to the stored [Elementary.components] map, where each entry's key consists of the kind type, theme resolved.
  Map<Type, ElementaryBase<dynamic>> components({
    Brightness? brightness,
  }) {
    return _configurationToMap(
      brightness: brightness,
      configuration: _components,
    );
  }

  /// Convert the [_fundations] passed to [ElementaryProperties.new]
  /// to the stored [fundations] map, where each entry's key consists of the kind type, theme resolved.
  Map<Type, ElementaryBase<dynamic>> fundations({
    Brightness? brightness,
  }) {
    return _configurationToMap(
      brightness: brightness,
      configuration: _fundations,
    );
  }

  Map<Type, ElementaryBase<dynamic>> _configurationToMap({
    required Configuration configuration,
    required Brightness? brightness,
  }) {
    final resolvedTheme = switch (brightness ?? forzeThemeMode) {
      Brightness.dark => configuration.dark,
      _ => configuration.light,
    };

    return Map<Type, ElementaryBase<dynamic>>.unmodifiable(
      {
        for (final ElementaryBase<dynamic> eBase in resolvedTheme.toSet())
          eBase.runtimeType: eBase,
      },
    );
  }
}
