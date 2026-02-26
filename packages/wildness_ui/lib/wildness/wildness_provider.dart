part of '../wildness.dart';

@immutable
class WildnessProvider extends InheritedWidget {
  const WildnessProvider({required this.data, required super.child, super.key});

  final Wildness data;

  @override
  bool updateShouldNotify(WildnessProvider oldWidget) => data != oldWidget.data;
}

@immutable
class WildnessComponentProvider<T extends WildnessBase> extends InheritedWidget {
  const WildnessComponentProvider({
    required this.data,
    required super.child,
    super.key,
  });

  final T data;

  @override
  bool updateShouldNotify(covariant WildnessComponentProvider<T> oldWidget) {
    return data != oldWidget.data;
  }
}
