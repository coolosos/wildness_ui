part of '../elementary.dart';

@immutable
class ElementaryProvider extends InheritedWidget {
  const ElementaryProvider({
    required this.data,
    required super.child,
    super.key,
  });

  final Elementary data;

  @override
  bool updateShouldNotify(ElementaryProvider oldWidget) =>
      data != oldWidget.data;
}
