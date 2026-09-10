part of 'wildness.dart';

@immutable
final class Configuration {
  const new({
    this.light = const Iterable<WildnessBase<dynamic>>.empty(),
    this.dark = const Iterable<WildnessBase<dynamic>>.empty(),
  });

  final Iterable<WildnessBase<dynamic>> dark;
  final Iterable<WildnessBase<dynamic>> light;

  Configuration copyWith({
    Iterable<WildnessBase<dynamic>>? light,
    Iterable<WildnessBase<dynamic>>? dark,
  }) {
    return Configuration(light: light ?? this.light, dark: dark ?? this.dark);
  }
}
