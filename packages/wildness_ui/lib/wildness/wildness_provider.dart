part of '../wildness.dart';

@immutable
class WildnessProvider extends InheritedWidget {
  const WildnessProvider({
    required this.data,
    required super.child,
    super.key,
  });

  final Wildness data;

  @override
  bool updateShouldNotify(WildnessProvider oldWidget) => data != oldWidget.data;
}
