part of '../wildness.dart';

@immutable
abstract base class ComponentTheme<T extends WildnessBase<dynamic>>
    extends InheritedTheme {
  const new({required this.data, required super.child, super.key});

  final T data;

  /// The extension's type.
  Object get type => T;

  @override
  bool updateShouldNotify(ComponentTheme<T> oldWidget) =>
      data != oldWidget.data;

  static W? wrappedThemeData<W extends InheritedTheme>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<W>();

  static Kind? kindThemeData<Kind extends WildnessBase<dynamic>>(
    BuildContext context,
  ) {
    final componentProvider = context
        .dependOnInheritedWidgetOfExactType<WildnessComponentProvider<Kind>>();
    if (componentProvider != null) {
      return componentProvider.data;
    }
    return Wildness.of(context, listen: true).component<Kind>();
  }
}
