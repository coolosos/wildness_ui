part of '../wildness.dart';

@immutable
abstract base class ComponentTheme<T extends WildnessBase<T>>
    extends InheritedTheme {
  const ComponentTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final T data;

  /// The extension's type.
  Object get type => T;

  @override
  bool updateShouldNotify(ComponentTheme<T> oldWidget) =>
      data != oldWidget.data;

  static W? wrappedThemeData<W extends ComponentTheme<WildnessBase>>(
    BuildContext context,
  ) =>
      context.dependOnInheritedWidgetOfExactType<W>();

  static Kind? kindThemeData<Kind extends WildnessBase>(
    BuildContext context,
  ) =>
      Wildness.of(context, listen: true).component<Kind>();
}
