import 'package:flutter/material.dart' show Theme;
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui/wildness.dart';

base class TestAppResourceData extends WildnessBase<TestAppResourceData> {
  const new({required this.configName});

  final String configName;

  @override
  TestAppResourceData copyWith({String? configName}) {
    return TestAppResourceData(configName: configName ?? this.configName);
  }

  @override
  TestAppResourceData lerp(WildnessBase<TestAppResourceData>? other, double t) {
    if (other is! TestAppResourceData) return this;
    return t < 0.5 ? this : other;
  }

  @override
  List<Object?> get props => [configName];
}

void main() {
  group('WildnessApp', () {
    testWidgets('Verify only one DefaultTextStyle is in the hierarchy', (
      tester,
    ) async {
      const config = WildnessProperties(forceThemeMode: Brightness.dark);
      const app = WildnessApp(
        wildnessProperties: config,
        defaultTextStyle: TextStyle(fontFamily: 'test'),
      );

      await tester.pumpWidget(app);

      final textStyleFinder = find.byType(DefaultTextStyle);
      expect(textStyleFinder, findsOneWidget);
    });

    testWidgets('Propagates custom defaultTextStyle fontFamily to child context', (
      tester,
    ) async {
      const config = WildnessProperties(forceThemeMode: Brightness.dark);
      String? resolvedFontFamily;

      final app = WildnessApp(
        wildnessProperties: config,
        defaultTextStyle: const TextStyle(fontFamily: 'CustomFont'),
        child: Builder(
          builder: (context) {
            resolvedFontFamily = context
                .dependOnInheritedWidgetOfExactType<DefaultTextStyle>()
                ?.style
                .fontFamily;
            return const SizedBox.shrink();
          },
        ),
      );

      await tester.pumpWidget(app);

      expect(resolvedFontFamily, 'CustomFont');
    });

    testWidgets('MediaQuery applies forced platform brightness correctly', (
      tester,
    ) async {
      Brightness? brightness;

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            forceThemeMode: Brightness.dark,
          ),
          child: Builder(
            builder: (context) {
              brightness = MediaQuery.platformBrightnessOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(brightness, Brightness.dark);

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            forceThemeMode: Brightness.light,
          ),
          child: Builder(
            builder: (context) {
              brightness = MediaQuery.platformBrightnessOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(brightness, Brightness.light);
    });

    testWidgets('withDefaultTheme sets forced brightness and custom theme', (
      tester,
    ) async {
      Brightness? brightness;

      await tester.pumpWidget(
        WildnessApp.withDefaultTheme(
          wildnessProperties: const WildnessProperties(
            forceThemeMode: Brightness.dark,
          ),
          child: Builder(
            builder: (context) {
              brightness = Theme.of(context).brightness;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(brightness, Brightness.dark);

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            forceThemeMode: Brightness.light,
          ),
          child: Builder(
            builder: (context) {
              brightness = Theme.of(context).brightness;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(brightness, Brightness.light);
    });

    testWidgets('clamps textScaler to minScaleFactor and maxScaleFactor', (
      tester,
    ) async {
      TextScaler? resolvedScaler;

      // 1. Below minScaleFactor (0.2 < 0.5)
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(0.2)),
          child: WildnessApp(
            wildnessProperties: const WildnessProperties(
              minScaleFactor: 0.5,
              maxScaleFactor: 1.5,
            ),
            child: Builder(
              builder: (context) {
                resolvedScaler = MediaQuery.textScalerOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(resolvedScaler?.scale(10), 5.0); // 10 * 0.5

      // 2. Above maxScaleFactor (3.0 > 1.5)
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: WildnessApp(
            wildnessProperties: const WildnessProperties(
              minScaleFactor: 0.5,
              maxScaleFactor: 1.5,
            ),
            child: Builder(
              builder: (context) {
                resolvedScaler = MediaQuery.textScalerOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(resolvedScaler?.scale(10), 15.0); // 10 * 1.5
    });

    testWidgets('wraps resources into WildnessComponentProvider hierarchy', (
      tester,
    ) async {
      const testResource = TestAppResourceData(configName: 'production');
      TestAppResourceData? resolvedResource;

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            resources: Configuration(light: [testResource]),
          ),
          child: Builder(
            builder: (context) {
              resolvedResource =
                  ComponentTheme.kindThemeData<TestAppResourceData>(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedResource?.configName, 'production');
    });

    testWidgets('renders safely with null child', (tester) async {
      const app = WildnessApp(
        wildnessProperties: WildnessProperties(),
      );

      await tester.pumpWidget(app);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    test('debugFillProperties attaches wildnessProperties property', () {
      const properties = WildnessProperties(minScaleFactor: 0.8);
      const app = WildnessApp(wildnessProperties: properties);

      final builder = DiagnosticPropertiesBuilder();
      app.debugFillProperties(builder);

      final property = builder.properties.firstWhere(
        (prop) => prop.name == 'wildnessProperties',
      );
      expect(property.value, properties);
    });
  });
}
