import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui/wildness.dart';

base class TestButtonThemeData extends WildnessBase<TestButtonThemeData> {
  const new({
    this.decoration = const BoxDecoration(color: Colors.blue),
    this.elevation = 2,
  });

  final BoxDecoration? decoration;
  final double elevation;

  @override
  TestButtonThemeData copyWith({
    BoxDecoration? decoration,
    double? elevation,
  }) {
    return TestButtonThemeData(
      decoration: decoration ?? this.decoration,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  TestButtonThemeData lerp(WildnessBase<TestButtonThemeData>? other, double t) {
    if (other is! TestButtonThemeData) return this;
    return TestButtonThemeData(
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
      elevation: elevation + (other.elevation - elevation) * t,
    );
  }

  @override
  List<Object?> get props => [decoration, elevation];
}

final class SubTestButtonThemeData extends TestButtonThemeData {
  const new({
    super.decoration = const BoxDecoration(color: Colors.green),
    super.elevation = 8,
  });
}

base class TestCardThemeData extends WildnessBase<TestCardThemeData> {
  const new({this.elevation = 4, this.borderRadius = 8});

  final double elevation;
  final double borderRadius;

  @override
  TestCardThemeData copyWith({double? elevation, double? borderRadius}) {
    return TestCardThemeData(
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  TestCardThemeData lerp(WildnessBase<TestCardThemeData>? other, double t) {
    if (other is! TestCardThemeData) return this;
    return TestCardThemeData(
      elevation: elevation + (other.elevation - elevation) * t,
      borderRadius: borderRadius + (other.borderRadius - borderRadius) * t,
    );
  }

  @override
  List<Object?> get props => [elevation, borderRadius];
}

base class TestResourceData extends WildnessBase<TestResourceData> {
  const new({required this.identifier});

  final String identifier;

  @override
  TestResourceData copyWith({String? identifier}) {
    return TestResourceData(identifier: identifier ?? this.identifier);
  }

  @override
  TestResourceData lerp(WildnessBase<TestResourceData>? other, double t) {
    if (other is! TestResourceData) return this;
    return t < 0.5 ? this : other;
  }

  @override
  List<Object?> get props => [identifier];
}

class _NonListeningWidget extends StatelessWidget {
  const new({required this.onBuild});

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    Wildness.of(context, listen: false);
    return const SizedBox.shrink();
  }
}

void main() {
  group('Wildness', () {
    const buttonLight = TestButtonThemeData(
      decoration: BoxDecoration(color: Colors.red),
    );
    const buttonDark = TestButtonThemeData(
      decoration: BoxDecoration(color: Colors.blue),
      elevation: 10,
    );
    const cardLight = TestCardThemeData(elevation: 4, borderRadius: 6);
    const cardDark = TestCardThemeData(elevation: 12, borderRadius: 18);
    const resourceLight = TestResourceData(identifier: 'light-asset');
    const resourceDark = TestResourceData(identifier: 'dark-asset');

    test('instantiation and props equality', () {
      const themeA = Wildness(
        physics: BouncingScrollPhysics(),
        components: {TestButtonThemeData: buttonLight},
        resources: {TestResourceData: resourceLight},
      );

      const themeB = Wildness(
        physics: BouncingScrollPhysics(),
        components: {TestButtonThemeData: buttonLight},
        resources: {TestResourceData: resourceLight},
      );

      const themeC = Wildness(
        physics: ClampingScrollPhysics(),
        components: {TestButtonThemeData: buttonDark},
      );

      expect(themeA, equals(themeB));
      expect(themeA == themeC, isFalse);
      expect(themeA.props, [
        const {TestButtonThemeData: buttonLight},
        const {TestResourceData: resourceLight},
        const BouncingScrollPhysics(),
      ]);
    });

    test('component lookup by generic type', () {
      const theme = Wildness(
        physics: ClampingScrollPhysics(),
        components: {TestButtonThemeData: buttonLight},
      );

      expect(theme.component<TestButtonThemeData>(), buttonLight);
      expect(theme.component<TestCardThemeData>(), isNull);
    });

    test('componentByName and componentByNameCast', () {
      const theme = Wildness(
        physics: ClampingScrollPhysics(),
        components: {
          TestButtonThemeData: buttonLight,
          TestCardThemeData: cardLight,
        },
      );

      expect(theme.componentByName('TestButtonThemeData'), buttonLight);
      expect(theme.componentByName('UnknownComponent'), isNull);

      final castSuccess = theme.componentByNameCast<TestButtonThemeData>(
        'TestButtonThemeData',
      );
      expect(castSuccess, buttonLight);

      final castMismatch = theme.componentByNameCast<TestCardThemeData>(
        'TestButtonThemeData',
      );
      expect(castMismatch, isNull);
    });

    test('resource lookup by generic type', () {
      const theme = Wildness(
        physics: ClampingScrollPhysics(),
        resources: {TestResourceData: resourceLight},
      );

      expect(theme.resource<TestResourceData>(), resourceLight);
      expect(theme.resource<TestButtonThemeData>(), isNull);
    });

    group('lerp interpolation', () {
      const sourceTheme = Wildness(
        physics: ClampingScrollPhysics(),
        components: {
          TestButtonThemeData: buttonLight,
          TestCardThemeData: cardLight,
        },
        resources: {TestResourceData: resourceLight},
      );

      const targetTheme = Wildness(
        physics: BouncingScrollPhysics(),
        components: {
          TestButtonThemeData: buttonDark,
          TestCardThemeData: cardDark,
        },
        resources: {TestResourceData: resourceDark},
      );

      test('interpolates at t = 0.0 (source values)', () {
        final interpolated = sourceTheme.lerp(targetTheme, 0);

        expect(interpolated.physics, const ClampingScrollPhysics());
        final button = interpolated.component<TestButtonThemeData>();
        expect(button?.elevation, 2);
        expect(button?.decoration?.color, Colors.red);
        expect(
          interpolated.resource<TestResourceData>()?.identifier,
          'light-asset',
        );
      });

      test('interpolates at t = 0.5 (midpoint values and target physics)', () {
        final interpolated = sourceTheme.lerp(targetTheme, 0.5);

        expect(interpolated.physics, const BouncingScrollPhysics());
        final button = interpolated.component<TestButtonThemeData>();
        expect(button?.elevation, 6.0); // (2 + 10) / 2
        final card = interpolated.component<TestCardThemeData>();
        expect(card?.elevation, 8.0); // (4 + 12) / 2
        expect(card?.borderRadius, 12.0); // (6 + 18) / 2
        expect(
          interpolated.resource<TestResourceData>()?.identifier,
          'dark-asset',
        );
      });

      test('interpolates at t = 1.0 (target values)', () {
        final interpolated = sourceTheme.lerp(targetTheme, 1);

        expect(interpolated.physics, const BouncingScrollPhysics());
        final button = interpolated.component<TestButtonThemeData>();
        expect(button?.elevation, 10);
        expect(button?.decoration?.color, Colors.blue);
        expect(
          interpolated.resource<TestResourceData>()?.identifier,
          'dark-asset',
        );
      });

      test('handles asymmetrical components across source and target', () {
        const onlyButtonTheme = Wildness(
          physics: ClampingScrollPhysics(),
          components: {TestButtonThemeData: buttonLight},
        );
        const onlyCardTheme = Wildness(
          physics: BouncingScrollPhysics(),
          components: {TestCardThemeData: cardDark},
        );

        final interpolated = onlyButtonTheme.lerp(onlyCardTheme, 0.5);
        expect(interpolated.component<TestButtonThemeData>(), buttonLight);
        expect(interpolated.component<TestCardThemeData>(), cardDark);
      });
    });

    group('replaceKind and replaceMultipleKind', () {
      const initialTheme = Wildness(
        physics: ClampingScrollPhysics(),
        components: {
          TestButtonThemeData: buttonLight,
          TestCardThemeData: cardLight,
        },
      );

      test('replaceKind replaces existing component kind immutably', () {
        const replacement = SubTestButtonThemeData(
          decoration: BoxDecoration(color: Colors.amber),
        );
        final updatedTheme = initialTheme.replaceKind<TestButtonThemeData>(
          kind: replacement,
        );

        expect(updatedTheme.component<TestButtonThemeData>(), replacement);
        expect(updatedTheme.component<TestCardThemeData>(), cardLight);
      });

      test('replaceKind throws AssertionError if kind does not exist', () {
        const emptyTheme = Wildness(
          physics: ClampingScrollPhysics(),
          components: {},
        );

        expect(
          () => emptyTheme.replaceKind<TestButtonThemeData>(kind: buttonLight),
          throwsA(isA<AssertionError>()),
        );
      });

      test('replaceMultipleKind replaces multiple existing component kinds', () {
        final updatedTheme = initialTheme.replaceMultipleKind(
          kinds: const {
            TestButtonThemeData: buttonDark,
            TestCardThemeData: cardDark,
          },
        );

        expect(updatedTheme.component<TestButtonThemeData>(), buttonDark);
        expect(updatedTheme.component<TestCardThemeData>(), cardDark);
      });

      test('replaceMultipleKind throws AssertionError if any kind is missing', () {
        expect(
          () => initialTheme.replaceMultipleKind(
            kinds: const {
              TestResourceData: resourceLight,
            },
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    test('copyWith produces clean partial modifications', () {
      const initial = Wildness(
        physics: ClampingScrollPhysics(),
        components: {TestButtonThemeData: buttonLight},
        resources: {TestResourceData: resourceLight},
      );

      final updated = initial.copyWith(
        physics: const BouncingScrollPhysics(),
        resources: const {TestResourceData: resourceDark},
      );

      expect(updated.physics, const BouncingScrollPhysics());
      expect(updated.components, const {TestButtonThemeData: buttonLight});
      expect(updated.resources, const {TestResourceData: resourceDark});
    });

    test('debugFillProperties attaches extensions diagnostic property', () {
      const theme = Wildness(
        physics: ClampingScrollPhysics(),
        components: {TestButtonThemeData: buttonLight},
      );

      final builder = DiagnosticPropertiesBuilder();
      theme.debugFillProperties(builder);

      final property = builder.properties.firstWhere(
        (prop) => prop.name == 'extensions',
      );
      expect(property.value, [buttonLight]);
    });

    testWidgets(
      'Wildness.of returns safe fallback when called outside WildnessProvider',
      (tester) async {
        late Wildness fallbackTheme;

        await tester.pumpWidget(
          Builder(
            builder: (context) {
              fallbackTheme = Wildness.of(context);
              return const SizedBox.shrink();
            },
          ),
        );

        expect(fallbackTheme.physics, isA<AlwaysScrollableScrollPhysics>());
        expect(fallbackTheme.components, isEmpty);
        expect(fallbackTheme.resources, isEmpty);
      },
    );

    testWidgets(
      'Wildness.of with listen: false does not trigger rebuild on updates',
      (tester) async {
        var buildCount = 0;
        final themeNotifier = ValueNotifier<Wildness>(
          const Wildness(
            physics: ClampingScrollPhysics(),
            components: {TestButtonThemeData: buttonLight},
          ),
        );

        final cachedChild = _NonListeningWidget(
          onBuild: () => buildCount++,
        );

        await tester.pumpWidget(
          ValueListenableBuilder<Wildness>(
            valueListenable: themeNotifier,
            child: cachedChild,
            builder: (context, currentTheme, child) {
              return WildnessProvider(
                data: currentTheme,
                child: child!,
              );
            },
          ),
        );

        expect(buildCount, 1);

        themeNotifier.value = const Wildness(
          physics: BouncingScrollPhysics(),
          components: {TestButtonThemeData: buttonDark},
        );
        await tester.pump();

        // No rebuild occurred because listen was false
        expect(buildCount, 1);
      },
    );
  });
}
