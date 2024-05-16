part of 'elementary.dart';

@immutable
class Configuration {
  const Configuration({
    this.light = const Iterable<ElementaryBase<dynamic>>.empty(),
    this.dark = const Iterable<ElementaryBase<dynamic>>.empty(),
  });

  final Iterable<ElementaryBase<dynamic>> dark;
  final Iterable<ElementaryBase<dynamic>> light;
}
