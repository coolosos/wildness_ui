import 'package:wildness_ui/wildness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widtget', () {
    testWidgets('Verify only one DefaultTestStyle',
        (WidgetTester tester) async {
      const config = WildnessProperties(
        forzeThemeMode: Brightness.dark,
      );
      const app = WildnessApp(
        wildnessProperties: config,
        defaultTextStyle: TextStyle(fontFamily: 'test'),
      );

      await tester.pumpWidget(app);

      var fab = find.byType(DefaultTextStyle);

      expect(fab, findsOneWidget);
    });

    testWidgets('Verify only one DefaultTestStyle',
        (WidgetTester tester) async {
      const config = WildnessProperties(
        forzeThemeMode: Brightness.dark,
        // TextStyle(fontFamily: 'test')
      );
      String? fontFamily;
      final app = WildnessApp(
        wildnessProperties: config,
        defaultTextStyle: const TextStyle(fontFamily: 'test'),
        child: Builder(
          builder: (context) {
            fontFamily = context
                .dependOnInheritedWidgetOfExactType<DefaultTextStyle>()
                ?.style
                .fontFamily;
            return const SizedBox();
          },
        ),
      );

      await tester.pumpWidget(app);

      expect(fontFamily, 'test');
    });

    testWidgets('MediaQuery set forzed brightness',
        (WidgetTester tester) async {
      Brightness? brightness;

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            forzeThemeMode: Brightness.dark,
          ),
          child: Builder(
            builder: (context) {
              brightness = MediaQuery.platformBrightnessOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(brightness, Brightness.dark);

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            forzeThemeMode: Brightness.light,
          ),
          child: Builder(
            builder: (context) {
              brightness = MediaQuery.platformBrightnessOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(brightness, Brightness.light);
    });

    testWidgets('theme set forzed brightness with custom theme',
        (WidgetTester tester) async {
      Brightness? brightness;

      await tester.pumpWidget(
        WildnessApp.withDefaultTheme(
          wildnessProperties: const WildnessProperties(
            forzeThemeMode: Brightness.dark,
          ),
          child: Builder(
            builder: (context) {
              brightness = Theme.of(context).brightness;

              return const SizedBox();
            },
          ),
        ),
      );

      expect(brightness, Brightness.dark);

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            forzeThemeMode: Brightness.light,
          ),
          child: Builder(
            builder: (context) {
              brightness = Theme.of(context).brightness;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(brightness, Brightness.light);
    });
  });
}
