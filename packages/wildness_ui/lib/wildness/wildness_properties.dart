part of '../wildness.dart';

@immutable
class WildnessProperties {
  /// Creates a [wildnessProperties] tha's used to configure wildnessUI
  ///
  /// The [forzeThemewildnessMode] will be used to set the theme,
  /// if you dont pass it, the system default setting is used
  /// fallback is light
  const WildnessProperties({
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
  /// To define components, pass an [Iterable] containing one or more [wildnessBase] and their kinds
  final Configuration _components;
  final Configuration _fundations;

  /// By default uses a system config
  /// if you pass a mode, it will be forced to this one.
  final Brightness? forzeThemeMode;

  /// The default Scroll physics for this theme.
  final ScrollPhysics physics;

  final double minScaleFactor;
  final double maxScaleFactor;

  /// Convert the [_components] passed to [wildnessProperties.new]
  /// to the stored [wildness.components] map, where each entry's key consists of the kind type, theme resolved.
  Map<Type, WildnessBase<dynamic>> components({
    Brightness? brightness,
  }) {
    return _configurationToMap(
      brightness: brightness,
      configuration: _components,
    );
  }

  /// Convert the [_fundations] passed to [wildnessProperties.new]
  /// to the stored [fundations] map, where each entry's key consists of the kind type, theme resolved.
  Map<Type, WildnessBase<dynamic>> fundations({
    Brightness? brightness,
  }) {
    return _configurationToMap(
      brightness: brightness,
      configuration: _fundations,
    );
  }

  Map<Type, WildnessBase<dynamic>> _configurationToMap({
    required Configuration configuration,
    required Brightness? brightness,
  }) {
    final resolvedTheme = switch (brightness ?? forzeThemeMode) {
      Brightness.dark => configuration.dark,
      _ => configuration.light,
    };

    return Map<Type, WildnessBase<dynamic>>.unmodifiable(
      {
        for (final WildnessBase<dynamic> eBase in resolvedTheme.toSet())
          eBase.runtimeType: eBase,
      },
    );
  }
}
