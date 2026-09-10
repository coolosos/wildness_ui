part of '../wildness.dart';

@immutable
class WildnessProperties {
  /// Creates a [WildnessProperties] that's used to configure wildnessUI
  ///
  /// The [forceThemeMode] will be used to set the theme,
  /// if you don't pass it, the system default setting is used
  /// fallback is light
  const new({
    this.forceThemeMode,
    this._components = const Configuration(),
    this._resources = const Configuration(),
    this.physics = const ClampingScrollPhysics(),
    this.minScaleFactor = 0.5,
    this.maxScaleFactor = 1.2,
  });

  /// Components of this theme.
  ///
  /// To define components, pass an [Iterable] containing one or more [WildnessBase] and their kinds
  final Configuration _components;
  final Configuration _resources;

  /// By default uses a system config
  /// if you pass a mode, it will be forced to this one.
  final Brightness? forceThemeMode;

  /// The default Scroll physics for this theme.
  final ScrollPhysics physics;

  final double minScaleFactor;
  final double maxScaleFactor;

  /// Convert the [_components] passed to [WildnessProperties]
  /// to the stored [Wildness.components] map, where each entry's key consists of the kind type, theme resolved.
  Map<Type, WildnessBase<dynamic>> components({Brightness? brightness}) {
    return _configurationToMap(
      brightness: brightness,
      configuration: _components,
    );
  }

  /// Convert the [_resources] passed to [WildnessProperties]
  /// to the stored [resources] map, where each entry's key consists of the kind type, theme resolved.
  Map<Type, WildnessBase<dynamic>> resources({Brightness? brightness}) {
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

    return Map<Type, WildnessBase<dynamic>>.unmodifiable({
      for (final WildnessBase<dynamic> eBase in resolvedTheme.toSet())
        eBase.runtimeType: eBase,
    });
  }

  WildnessProperties copyWith({
    Brightness? forceThemeMode,
    Configuration? components,
    Configuration? resources,
    ScrollPhysics? physics,
    double? minScaleFactor,
    double? maxScaleFactor,
  }) {
    return WildnessProperties(
      forceThemeMode: forceThemeMode ?? this.forceThemeMode,
      components: components ?? _components,
      resources: resources ?? _resources,
      physics: physics ?? this.physics,
      minScaleFactor: minScaleFactor ?? this.minScaleFactor,
      maxScaleFactor: maxScaleFactor ?? this.maxScaleFactor,
    );
  }
}
