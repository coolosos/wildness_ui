part of 'elementary.dart';

@immutable
class ElementaryProvider extends InheritedWidget {
  const ElementaryProvider({
    required this.data,
    required super.child,
    super.key,
  });

  final ElementaryComponents data;

  static ElementaryComponents of(BuildContext context, {bool listen = true}) {
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
    return inheritedTheme?.data ?? ElementaryComponents.fallback();
  }

  @override
  bool updateShouldNotify(ElementaryProvider oldWidget) =>
      data != oldWidget.data;
}
