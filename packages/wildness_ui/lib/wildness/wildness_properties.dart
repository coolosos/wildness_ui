part of '../wildness.dart';

@immutable
class WildnessProperties {
  /// Creates a [wildnessProperties] that's used to configure wildnessUI
  ///
  /// The [forceThemeMode] will be used to set the theme,
  /// if you don't pass it, the system default setting is used
  /// fallback is light
  const WildnessProperties({
    this.forceThemeMode,
    Configuration components = const Configuration(),
    Configuration resources = const Configuration(),
    this.physics = const ClampingScrollPhysics(),
    this.minScaleFactor = 0.5,
    this.maxScaleFactor = 1.2,
  })  : _resources = resources,
        _components = components;

  /// Components of this theme.
  ///
  /// To define components, pass an [Iterable] containing one or more [wildnessBase] and their kinds
  final Configuration _components;
  final Configuration _resources;

  /// By default uses a system config
  /// if you pass a mode, it will be forced to this one.
  final Brightness? forceThemeMode;

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

  /// Convert the [_resources] passed to [wildnessProperties.new]
  /// to the stored [resources] map, where each entry's key consists of the kind type, theme resolved.
  Map<Type, WildnessBase<dynamic>> resources({
    Brightness? brightness,
  }) {
    return _configurationToMap(
      brightness: brightness,
      configuration: _resources,
    );
  }

  Map<Type, WildnessBase<dynamic>> _configurationToMap({
    required Configuration configuration,
    required Brightness? brightness,
  }) {
    final resolvedTheme = switch (brightness ?? forceThemeMode) {
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
