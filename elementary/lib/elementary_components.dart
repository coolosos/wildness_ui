part of 'elementary.dart';

@immutable
class ElementaryComponents extends Equatable with Diagnosticable {
  const ElementaryComponents({
    required this.physics,
    this.components = const {},
  });

  factory ElementaryComponents.themeStyleOf({
    required BuildContext context,
    required ElementaryProperties config,
  }) {
    return ElementaryComponents(
      components: config.componentsIterableToMap(context),
      physics: config.physics,
    );
  }

  factory ElementaryComponents.fallback() {
    return const ElementaryComponents(
      physics: AlwaysScrollableScrollPhysics(),
      components: {},
    );
  }

  final Map<Type, ElementaryBase<dynamic>> components;
  final ScrollPhysics physics;

  /// Used to obtain a particular [ElementaryBase] from [components].
  ///
  /// Obtain with `ElementaryTheme.of(context).component<MyThemeComponent>()`.
  ///
  /// See [components] for an interactive example.
  T? component<T>() => (components[T] as T?);

  /// Linearly interpolate between two [components].
  ///
  /// Includes all theme compoents in [a] and [b].
  ///
  /// {@macro dart.ui.shadow.lerp}
  Map<Type, ElementaryBase<dynamic>> _lerpThemeComponents(
    ElementaryComponents b,
    double t,
  ) {
    // Lerp [a].
    final Map<Type, ElementaryBase<dynamic>> newComponents =
        components.map((id, componentA) {
      final ElementaryBase<dynamic>? componentB = b.components[id];
      return MapEntry<Type, ElementaryBase<dynamic>>(
        id,
        componentA.lerp(componentB, t),
      );
    });
    // Add [b]-only components.
    newComponents.addEntries(
      b.components.entries.where(
        (MapEntry<Type, ElementaryBase<dynamic>> entry) =>
            !components.containsKey(entry.key),
      ),
    );

    return newComponents;
  }

  /// Linearly interpolate between two themes.
  ElementaryComponents lerp(
    ElementaryComponents b,
    double t,
  ) {
    return ElementaryComponents(
      components: _lerpThemeComponents(b, t),
      physics: t < 0.5 ? physics : b.physics,
    );
  }

  ElementaryComponents componentsLerp(
    ElementaryComponents b,
    double t,
  ) {
    return ElementaryComponents(
      components: _lerpThemeComponents(b, t),
      physics: physics,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      IterableProperty<ElementaryBase<dynamic>>(
        'extensions',
        components.values,
        level: DiagnosticLevel.debug,
      ),
    );
  }

  @override
  List<Object?> get props => [
        components,
        physics,
      ];

  ///Replace all kinds provide.
  ///
  ///If the kind exist already in Elementary components change the value of the map.key for the current value of map.value.
  ///You can replace one by one using [replaceKind], however if you only want to change a kind in the current context
  ///must be recomendated to use Elementary(KindToReplace)Theme.
  ///
  ///Usually use in [ElementaryAnimatedTheme] widget.
  ElementaryComponents replaceMultipleKind({
    required Map<Type, ElementaryBase<dynamic>> kinds,
  }) {
    //Check if the component kind exists in the provide theme components
    for (MapEntry<Type, ElementaryBase<dynamic>> kind in kinds.entries) {
      assert(
        components[kind.key]?.runtimeType != null,
        "Kind must be the same Type or Covariant as the replacemente kind",
      );
    }
    //Return copyWith of the [ElementaryThemeData] components must be unmodifiable
    //for being sure of no modifications and no repit hash
    return copyWith(
      components: Map.unmodifiable(Map.from(components)..addAll(kinds)),
    );
  }

  ///Replace current kind in the ElementaryThemeData.
  ///
  ///If the kind exist already in Elementary components and is Type or Covariant
  ///of the provide [Kind] then replace the [Kind] type for the new kind.
  ///
  ///
  ///Usually use in [ElementaryAnimatedTheme] widget. If you want to change the
  ///current context for instance it's recommended to use Elementary(KindToReplace)Theme.
  ElementaryComponents replaceKind<Kind extends ElementaryBase>({
    required ElementaryBase<dynamic> kind,
  }) {
    //Check if the component kind exists in the provide theme components and is the type
    assert(
      components[kind.type] is Kind,
      "Kind must be the same Type or Covariant as the replacemente kind",
    );
    //Return copyWith of the [ElementaryThemeData] components must be unmodifiable
    //for being sure of no modifications and no repit hash
    return copyWith(
      components: Map.unmodifiable(Map.from(components)..addAll({Kind: kind})),
    );
  }

  ElementaryComponents copyWith({
    Map<Type, ElementaryBase<dynamic>>? components,
    ScrollPhysics? physics,
  }) {
    return ElementaryComponents(
      components: components ?? this.components,
      physics: physics ?? this.physics,
    );
  }
}
