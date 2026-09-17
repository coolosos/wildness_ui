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
    final provider = InheritedModel.inheritFrom<WildnessProvider>(
      context,
      aspect: Kind,
    );
    return provider?.data.component<Kind>() ?? provider?.data.resource<Kind>();
  }

  /// Obtains a [WildnessBase] component matching [name] from the nearest [WildnessProvider].
  static WildnessBase<dynamic>? componentByName(
    BuildContext context,
    String name,
  ) {
    return Wildness.of(context, listen: true).componentByName(name);
  }

  /// Obtains a [WildnessBase] component matching [name] cast to [T] from the nearest [WildnessProvider].
  ///
  /// Also checks if an overriding [WildnessComponentProvider<T>] matching [name] is in the local context.
  static T? componentByNameCast<T extends WildnessBase<dynamic>>(
    BuildContext context,
    String name,
  ) {
    final componentProvider = context
        .dependOnInheritedWidgetOfExactType<WildnessComponentProvider<T>>();
    if (componentProvider != null && componentProvider.data.name == name) {
      return componentProvider.data;
    }
    return Wildness.of(context, listen: true).componentByNameCast<T>(name);
  }
}
