part of '../wildness.dart';

/// An interface that defines components to a [wildness] object.
@immutable
abstract base class WildnessBase<T> extends Equatable with Diagnosticable {
  /// Enable const constructor for subclasses.
  const WildnessBase();

  /// The extension's type.
  Type get type => T;

  /// Creates a copy of this theme extension with the given fields
  /// replaced by the non-null parameter values.
  WildnessBase<T> copyWith();

  /// Linearly interpolate with another [wildnessBase] object.
  ///
  /// {@macro dart.ui.shadow.lerp}
  WildnessBase<T> lerp(WildnessBase<T>? other, double t);
}
