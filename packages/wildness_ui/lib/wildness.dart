library wildness;

import '../library.dart';
import 'theme/custom_default_theme.dart';

export '../library.dart';

part 'wildness/wildness_properties.dart';
part 'configuration.dart';
part 'wildness/wildness_app.dart';
part 'wildness/wildness_provider.dart';
part 'base/component_theme.dart';
part 'base/wildness_base.dart';
part 'wildness_builder.dart';

@immutable
class Wildness extends Equatable with Diagnosticable {
  const Wildness({
    required this.physics,
    this.components = const {},
    this.fundations = const {},
  });

  static Wildness of(BuildContext context, {bool listen = true}) {
    final WildnessProvider? inheritedTheme = listen
        ? //searches only for InheritedWidget
        context.dependOnInheritedWidgetOfExactType<WildnessProvider>()
        : //does not establish a relationship with the target in the way that dependOnInheritedWidgetOfExactType does.
        (context
            .getElementForInheritedWidgetOfExactType<WildnessProvider>()
            ?.widget as WildnessProvider?);
    //expensive, searches for any Widget subclass
    // context.findAncestorWidgetOfExactType<_InheritedWildnessTheme>();

    //! No podemos retornar una excepcion aqui, para permitir usar los componentes sueltos sin theme
    return inheritedTheme?.data ??
        const Wildness(
          physics: AlwaysScrollableScrollPhysics(),
          components: {},
          fundations: {},
        );
  }

  final Map<Type, WildnessBase<dynamic>> components;
  final Map<Type, WildnessBase<dynamic>> fundations;
  final ScrollPhysics physics;

  /// Used to obtain a particular [WildnessBase] from [components].
  ///
  /// Obtain with `WildnessTheme.of(context).component<MyThemeComponent>()`.
  ///
  /// See [components] for an interactive example.
  T? component<T>() => (components[T] as T?);

  T? fundation<T>() => (fundations[T] as T?);

  /// Linearly interpolate between two [components].
  ///
  /// Includes all theme compoents in [a] and [b].
  ///
  /// {@macro dart.ui.shadow.lerp}
  Map<Type, WildnessBase<dynamic>> _lerpWildnessBase(
    Map<Type, WildnessBase<dynamic>> elementsBase,
    double t,
  ) {
    // Lerp [a].
    final Map<Type, WildnessBase<dynamic>> newComponents =
        components.map((id, componentA) {
      final WildnessBase<dynamic>? componentB = elementsBase[id];
      return MapEntry<Type, WildnessBase<dynamic>>(
        id,
        componentA.lerp(componentB, t),
      );
    });
    // Add [b]-only components.
    newComponents.addEntries(
      elementsBase.entries.where(
        (MapEntry<Type, WildnessBase<dynamic>> entry) =>
            !components.containsKey(entry.key),
      ),
    );

    return newComponents;
  }

  /// Linearly interpolate between two themes.
  Wildness lerp(
    Wildness b,
    double t,
  ) {
    return Wildness(
      components: _lerpWildnessBase(b.components, t),
      physics: t < 0.5 ? physics : b.physics,
      fundations: _lerpWildnessBase(b.fundations, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      IterableProperty<WildnessBase<dynamic>>(
        'extensions',
        components.values,
        level: DiagnosticLevel.debug,
      ),
    );
  }

  @override
  List<Object?> get props => [
        components,
        fundations,
        physics,
      ];

  ///Replace all kinds provide.
  ///
  ///If the kind exist already in wildness components change the value of the map.key for the current value of map.value.
  ///You can replace one by one using [replaceKind], however if you only want to change a kind in the current context
  ///must be recomendated to use wildness(KindToReplace)Theme.
  ///
  ///Usually use in [wildnessAnimatedTheme] widget.
  Wildness replaceMultipleKind({
    required Map<Type, WildnessBase<dynamic>> kinds,
  }) {
    //Check if the component kind exists in the provide theme components
    for (MapEntry<Type, WildnessBase<dynamic>> kind in kinds.entries) {
      assert(
        components[kind.key]?.runtimeType != null,
        "Kind must be the same Type or Covariant as the replacemente kind",
      );
    }
    //Return copyWith of the [wildnessThemeData] components must be unmodifiable
    //for being sure of no modifications and no repit hash
    return copyWith(
      components: Map.unmodifiable(Map.from(components)..addAll(kinds)),
    );
  }

  ///Replace current kind in the wildnessThemeData.
  ///
  ///If the kind exist already in wildness components and is Type or Covariant
  ///of the provide [Kind] then replace the [Kind] type for the new kind.
  ///
  ///
  ///Usually use in [wildnessAnimatedTheme] widget. If you want to change the
  ///current context for instance it's recommended to use wildness(KindToReplace)Theme.
  Wildness replaceKind<Kind extends WildnessBase>({
    required WildnessBase<dynamic> kind,
  }) {
    //Check if the component kind exists in the provide theme components and is the type
    assert(
      components[kind.type] is Kind,
      "Kind must be the same Type or Covariant as the replacemente kind",
    );
    //Return copyWith of the [wildnessThemeData] components must be unmodifiable
    //for being sure of no modifications and no repit hash
    return copyWith(
      components: Map.unmodifiable(Map.from(components)..addAll({Kind: kind})),
    );
  }

  Wildness copyWith({
    Map<Type, WildnessBase<dynamic>>? components,
    Map<Type, WildnessBase<dynamic>>? fundations,
    ScrollPhysics? physics,
  }) {
    return Wildness(
      components: components ?? this.components,
      fundations: fundations ?? this.fundations,
      physics: physics ?? this.physics,
    );
  }
}
