import 'package:elementary_ui/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
            components: Configuration(
              light: [
                normal,
                replica,
                coolKind,
              ],
            ),
          );

          expect(config.components().length, 2);
        },
      );
      test(
        'components ThemeMode',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            components: Configuration(
              light: [
                replica,
              ],
            ),
          );

          expect(config.components().length, 0);
        },
      );
      test(
        'no found kind',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            components: Configuration(
              light: [
                coolKind,
              ],
            ),
          );

          expect(config.components()[CoolButtonThemeData], isNull);
        },
      );
      test(
        'found kind',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.light,
            components: Configuration(
              light: [
                coolKind,
              ],
            ),
          );

          expect(
            config.components()[CoolKindButtonThemeData],
            isNotNull,
          );
        },
      );

      test(
        'type of kind no found base',
        () {
          const config = ElementaryProperties(
            forzeThemeMode: Brightness.dark,
            // components: [
            //   Configuration<CoolButtonThemeData>.same(
            //     normal,
            //   ),
            // ],
            components: Configuration(
              light: [
                normal,
              ],
            ),
          );

          expect(
            config.components()[CoolKindButtonThemeData],
            isNull,
          );
        },
      );
    },
  );
}
