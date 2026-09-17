part of 'wildness.dart';

/// An abstract interface for defining groups of [WildnessBase] components.
abstract class Components {
  /// Enable const constructor for subclasses.
  const new();

  /// Returns the list of [WildnessBase] components.
  List<WildnessBase<dynamic>> get components;
}

/// An abstract interface for defining groups of [WildnessBase] resources (tokens, colors, typography).
abstract class Resources {
  /// Enable const constructor for subclasses.
  const new();

  /// Returns the list of [WildnessBase] resources.
  List<WildnessBase<dynamic>> get resources;
}

@immutable
final class Configuration {
  const new({
    this.light = const Iterable<WildnessBase<dynamic>>.empty(),
    this.dark = const Iterable<WildnessBase<dynamic>>.empty(),
  });

  /// Creates a [Configuration] from [Components] instances for light and dark modes.
  factory fromComponents({
    Components? light,
    Components? dark,
  }) =>
      Configuration(
        light: light?.components ?? const Iterable<WildnessBase<dynamic>>.empty(),
        dark: dark?.components ?? const Iterable<WildnessBase<dynamic>>.empty(),
      );

  /// Creates a [Configuration] from [Resources] instances for light and dark modes.
  factory fromResources({
    Resources? light,
    Resources? dark,
  }) =>
      Configuration(
        light: light?.resources ?? const Iterable<WildnessBase<dynamic>>.empty(),
        dark: dark?.resources ?? const Iterable<WildnessBase<dynamic>>.empty(),
      );

  final Iterable<WildnessBase<dynamic>> dark;
  final Iterable<WildnessBase<dynamic>> light;

  Configuration copyWith({
    Iterable<WildnessBase<dynamic>>? light,
    Iterable<WildnessBase<dynamic>>? dark,
  }) {
    return Configuration(light: light ?? this.light, dark: dark ?? this.dark);
  }
}
