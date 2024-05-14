import 'package:elementary/elementary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elementary/library.dart';

base class CoolButtonThemeData extends ElementaryBase<CoolButtonThemeData> {
  const CoolButtonThemeData({required this.decoration});

  final BoxDecoration? decoration;

  @override
  ElementaryBase<CoolButtonThemeData> copyWith({
    BoxDecoration? decoration,
  }) {
    return CoolButtonThemeData(decoration: decoration ?? this.decoration);
  }

  @override
  ElementaryBase<CoolButtonThemeData> lerp(
    ElementaryBase<CoolButtonThemeData>? other,
    double t,
  ) {
    if (other is! CoolButtonThemeData) {
      return this;
    }
    return CoolButtonThemeData(
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
    );
  }

  @override
  List<Object?> get props => [
        decoration,
      ];
}

final class CoolKindButtonThemeData extends CoolButtonThemeData {
  const CoolKindButtonThemeData({
    super.decoration = const BoxDecoration(
      color: Colors.amber,
      shape: BoxShape.rectangle,
    ),
  });
}

const normal = CoolButtonThemeData(
  decoration: BoxDecoration(
    color: Colors.redAccent,
    shape: BoxShape.rectangle,
  ),
);
const replica = CoolButtonThemeData(
  decoration: BoxDecoration(
    color: Colors.amber,
    shape: BoxShape.rectangle,
  ),
);

const coolKind = CoolKindButtonThemeData(
  decoration: BoxDecoration(
    color: Colors.red,
    shape: BoxShape.rectangle,
  ),
);

void main() {
  group(
    'Elementary Components',
    () {
      test(
        'components size by type',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.light,
            components: [
              Configuration(
                light: normal,
                dark: normal,
              ),
              Configuration(
                light: replica,
                dark: replica,
              ),
              Configuration(
                light: coolKind,
                dark: coolKind,
              ),
            ],
          );

          expect(config.componentsIterableToMap().length, 2);
        },
      );
      test(
        'components ThemeMode',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            components: [
              Configuration.same(
                replica,
              ),
            ],
          );

          expect(config.componentsIterableToMap().length, 1);
        },
      );
      test(
        'no found kind',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            components: [
              Configuration<CoolKindButtonThemeData>.same(
                coolKind,
              ),
            ],
          );

          expect(config.componentsIterableToMap()[CoolButtonThemeData], isNull);
        },
      );
      test(
        'found kind',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            components: [
              Configuration.same(
                coolKind,
              ),
            ],
          );

          expect(
            config.componentsIterableToMap()[CoolKindButtonThemeData],
            isNotNull,
          );
        },
      );

      test(
        'use type of kind for find',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            components: [
              Configuration<CoolButtonThemeData>.same(
                coolKind,
              ),
            ],
          );

          expect(
            config.componentsIterableToMap()[CoolKindButtonThemeData],
            isNotNull,
          );
        },
      );

      test(
        'use type of kind for find 2',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            components: [
              Configuration<CoolButtonThemeData>.same(
                normal,
              ),
            ],
          );

          expect(
            config.componentsIterableToMap()[CoolKindButtonThemeData],
            isNull,
          );
        },
      );
    },
  );
}
