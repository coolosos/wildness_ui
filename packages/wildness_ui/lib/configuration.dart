part of 'wildness.dart';

@immutable
class Configuration {
  const Configuration({
    this.light = const Iterable<WildnessBase<dynamic>>.empty(),
    this.dark = const Iterable<WildnessBase<dynamic>>.empty(),
  });

  final Iterable<WildnessBase<dynamic>> dark;
  final Iterable<WildnessBase<dynamic>> light;
}
