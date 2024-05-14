part of '../elementary.dart';

@immutable
class Configuration<Mode extends ElementaryBase> {
  const Configuration({
    required this.light,
    required this.dark,
  });

  const Configuration.same(Mode same)
      : dark = same,
        light = same;

  final Mode dark;
  final Mode light;
}
