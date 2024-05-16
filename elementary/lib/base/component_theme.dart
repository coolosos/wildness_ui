part of '../elementary.dart';

@immutable
abstract base class ComponentTheme<T extends ElementaryBase<T>>
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

  static W? wrappedThemeData<W extends ComponentTheme<ElementaryBase>>(
    BuildContext context,
  ) =>
      context.dependOnInheritedWidgetOfExactType<W>();

  static Kind? kindThemeData<Kind extends ElementaryBase>(
    BuildContext context,
  ) =>
      Elementary.of(context).component<Kind>();
}
