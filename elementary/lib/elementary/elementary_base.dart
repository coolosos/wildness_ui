part of '../elementary.dart';

/// An interface that defines components to a [Elementary] object.
@immutable
abstract base class ElementaryBase<T> extends Equatable with Diagnosticable {
  /// Enable const constructor for subclasses.
  const ElementaryBase();

  /// The extension's type.
  Type get type => T;

  /// Creates a copy of this theme extension with the given fields
  /// replaced by the non-null parameter values.
  ElementaryBase<T> copyWith();

  /// Linearly interpolate with another [ElementaryBase] object.
  ///
  /// {@macro dart.ui.shadow.lerp}
  ElementaryBase<T> lerp(ElementaryBase<T>? other, double t);
}
