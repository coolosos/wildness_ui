part of '../wildness.dart';

@immutable
final class WildnessProvider extends InheritedWidget {
  const new({required this.data, required super.child, super.key});

  final Wildness data;

  @override
  bool updateShouldNotify(WildnessProvider oldWidget) => data != oldWidget.data;
}

@immutable
final class WildnessComponentProvider<T extends WildnessBase<dynamic>>
    extends InheritedWidget {
  const new({required this.data, required super.child, super.key});

  final T data;

  @override
  bool updateShouldNotify(covariant WildnessComponentProvider<T> oldWidget) {
    return data != oldWidget.data;
  }
}
