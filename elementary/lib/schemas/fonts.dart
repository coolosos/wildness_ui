part of '../elementary.dart';

@immutable
base class ElementaryFontsFamilySchema
    extends ElementaryBase<ElementaryFontsFamilySchema> {
  const ElementaryFontsFamilySchema({
    this.primary,
    this.highlight,
  });

  final String? primary;
  final String? highlight;

  @override
  ElementaryFontsFamilySchema lerp(
    ElementaryBase<ElementaryFontsFamilySchema>? other,
    double t,
  ) {
    if (other is! ElementaryFontsFamilySchema) {
      return this;
    }
    return ElementaryFontsFamilySchema(
      primary: t < 0.5 ? primary : other.primary,
      highlight: t < 0.5 ? highlight : other.highlight,
    );
  }

  @override
  ElementaryFontsFamilySchema copyWith({
    String? primary,
    String? highlight,
  }) =>
      ElementaryFontsFamilySchema(
        highlight: highlight ?? this.highlight,
        primary: primary ?? this.primary,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('primary', primary));
    properties.add(StringProperty('highlight', highlight));
  }

  @override
  List<Object?> get props => [
        primary,
        highlight,
      ];
}
