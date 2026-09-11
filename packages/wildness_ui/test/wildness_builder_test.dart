import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui/wildness.dart';

base class TestBuilderThemeData extends WildnessBase<TestBuilderThemeData> {
  const new({required this.title});

  final String title;

  @override
  TestBuilderThemeData copyWith({String? title}) {
    return TestBuilderThemeData(title: title ?? this.title);
  }

  @override
  TestBuilderThemeData lerp(WildnessBase<TestBuilderThemeData>? other, double t) {
    if (other is! TestBuilderThemeData) return this;
    return t < 0.5 ? this : other;
  }

  @override
  List<Object?> get props => [title];
}

void main() {
  group('WildnessBuilder', () {
    testWidgets('provides BuildContext and Wildness themeData to builder', (
      tester,
    ) async {
      const themeData = TestBuilderThemeData(title: 'Initial Theme');
      String? capturedTitle;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WildnessApp(
            wildnessProperties: const WildnessProperties(
              components: Configuration(light: [themeData]),
            ),
            child: WildnessBuilder(
              builder: (context, theme) {
                capturedTitle =
                    theme.component<TestBuilderThemeData>()?.title;
                return Text(capturedTitle ?? 'none');
              },
            ),
          ),
        ),
      );

      expect(capturedTitle, 'Initial Theme');
      expect(find.text('Initial Theme'), findsOneWidget);
    });

    testWidgets('rebuilds automatically when ancestor theme changes', (
      tester,
    ) async {
      var buildCount = 0;
      final propertiesNotifier = ValueNotifier<WildnessProperties>(
        const WildnessProperties(
          components: Configuration(
            light: [TestBuilderThemeData(title: 'V1')],
          ),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ValueListenableBuilder<WildnessProperties>(
            valueListenable: propertiesNotifier,
            builder: (context, properties, _) {
              return WildnessApp(
                wildnessProperties: properties,
                child: WildnessBuilder(
                  builder: (context, theme) {
                    buildCount++;
                    final title =
                        theme.component<TestBuilderThemeData>()?.title ?? '';
                    return Text(title);
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(buildCount, 1);
      expect(find.text('V1'), findsOneWidget);

      propertiesNotifier.value = const WildnessProperties(
        components: Configuration(
          light: [TestBuilderThemeData(title: 'V2')],
        ),
      );
      await tester.pump();

      expect(buildCount, 2);
      expect(find.text('V2'), findsOneWidget);
    });

    testWidgets('renders fallback default theme when outside WildnessApp', (
      tester,
    ) async {
      Wildness? capturedTheme;

      await tester.pumpWidget(
        WildnessBuilder(
          builder: (context, theme) {
            capturedTheme = theme;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(capturedTheme, isNotNull);
      expect(capturedTheme?.physics, isA<AlwaysScrollableScrollPhysics>());
      expect(capturedTheme?.components, isEmpty);
    });
  });
}
