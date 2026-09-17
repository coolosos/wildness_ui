part of '../wildness.dart';

@immutable
final class WildnessProvider extends InheritedModel<Type> {
  const new({required this.data, required super.child, super.key});

  final Wildness data;

  @override
  bool updateShouldNotify(WildnessProvider oldWidget) => data != oldWidget.data;

  @override
  bool updateShouldNotifyDependent(
    WildnessProvider oldWidget,
    Set<Type> dependencies,
  ) {
    for (final aspect in dependencies) {
      if (data.components[aspect] != oldWidget.data.components[aspect] ||
          data.resources[aspect] != oldWidget.data.resources[aspect]) {
        return true;
      }
    }
    return false;
  }
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
