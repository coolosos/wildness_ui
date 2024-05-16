library elementary;

import '../library.dart';
import 'theme/custom_default_theme.dart';

part 'elementary/elementary_properties.dart';
part 'elementary/elementary_base.dart';
part 'configuration.dart';
part 'elementary/elementary_app.dart';
part 'elementary/elementary_provider.dart';

@immutable
class Elementary extends Equatable with Diagnosticable {
  const Elementary({
    required this.physics,
    this.components = const {},
    this.fundations = const {},
  });

  static Elementary of(BuildContext context, {bool listen = true}) {
    final ElementaryProvider? inheritedTheme = listen
        ? //searches only for InheritedWidget
        context.dependOnInheritedWidgetOfExactType<ElementaryProvider>()
        : //does not establish a relationship with the target in the way that dependOnInheritedWidgetOfExactType does.
        (context
            .getElementForInheritedWidgetOfExactType<ElementaryProvider>()
            ?.widget as ElementaryProvider?);
    //expensive, searches for any Widget subclass
    // context.findAncestorWidgetOfExactType<_InheritedElementaryTheme>();

    //! No podemos retornar una excepcion aqui, para permitir usar los componentes sueltos sin theme
    return inheritedTheme?.data ??
        const Elementary(
          physics: AlwaysScrollableScrollPhysics(),
          components: {},
          fundations: {},
        );
  }

  final Map<Type, ElementaryBase<dynamic>> components;
  final Map<Type, ElementaryBase<dynamic>> fundations;
  final ScrollPhysics physics;

  /// Used to obtain a particular [ElementaryBase] from [components].
  ///
  /// Obtain with `ElementaryTheme.of(context).component<MyThemeComponent>()`.
  ///
  /// See [components] for an interactive example.
  T? component<T>() => (components[T] as T?);

  T? fundation<T>() => (fundations[T] as T?);

  /// Linearly interpolate between two [components].
  ///
  /// Includes all theme compoents in [a] and [b].
  ///
  /// {@macro dart.ui.shadow.lerp}
  Map<Type, ElementaryBase<dynamic>> _lerpElementaryBase(
    Map<Type, ElementaryBase<dynamic>> elementsBase,
    double t,
  ) {
    // Lerp [a].
    final Map<Type, ElementaryBase<dynamic>> newComponents =
        components.map((id, componentA) {
      final ElementaryBase<dynamic>? componentB = elementsBase[id];
      return MapEntry<Type, ElementaryBase<dynamic>>(
        id,
        componentA.lerp(componentB, t),
      );
    });
    // Add [b]-only components.
    newComponents.addEntries(
      elementsBase.entries.where(
        (MapEntry<Type, ElementaryBase<dynamic>> entry) =>
            !components.containsKey(entry.key),
      ),
    );

    return newComponents;
  }

  /// Linearly interpolate between two themes.
  Elementary lerp(
    Elementary b,
    double t,
  ) {
    return Elementary(
      components: _lerpElementaryBase(b.components, t),
      physics: t < 0.5 ? physics : b.physics,
      fundations: _lerpElementaryBase(b.fundations, t),
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
        fundations,
        physics,
      ];

  ///Replace all kinds provide.
  ///
  ///If the kind exist already in Elementary components change the value of the map.key for the current value of map.value.
  ///You can replace one by one using [replaceKind], however if you only want to change a kind in the current context
  ///must be recomendated to use Elementary(KindToReplace)Theme.
  ///
  ///Usually use in [ElementaryAnimatedTheme] widget.
  Elementary replaceMultipleKind({
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
  Elementary replaceKind<Kind extends ElementaryBase>({
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

  Elementary copyWith({
    Map<Type, ElementaryBase<dynamic>>? components,
    Map<Type, ElementaryBase<dynamic>>? fundations,
    ScrollPhysics? physics,
  }) {
    return Elementary(
      components: components ?? this.components,
      fundations: fundations ?? this.fundations,
      physics: physics ?? this.physics,
    );
  }
}
