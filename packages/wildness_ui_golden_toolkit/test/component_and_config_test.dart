import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('Component', () {
    test('instantiation preserves parameters', () {
      const widget = Text('Sample');
      const component = Component(
        name: 'sample_scenario',
        widget: widget,
        textScaleFactor: 1.5,
      );

      expect(component.name, 'sample_scenario');
      expect(component.widget, widget);
      expect(component.textScaleFactor, 1.5);
    });
  });

  group('GoldenRenderConfig', () {
    test('default constructor provides expected standard size and pump duration', () {
      const config = GoldenRenderConfig();
      expect(config.size, const Size(800, 600));
      expect(config.devicePixelRatio, 1);
      expect(config.additionalPump, const Duration(milliseconds: 16));
    });

    test('device factory constructor maps properties from TestDevice', () {
      final config = GoldenRenderConfig.device(Devices.iphone11);
      expect(config.size, Devices.iphone11.size);
      expect(config.devicePixelRatio, Devices.iphone11.devicePixelRatio);
      expect(config.additionalPump, const Duration(milliseconds: 120));
    });
  });

  group('wildnessWidgetWrapper and wildnessApp', () {
    testWidgets('wildnessApp wraps child in WildnessApp.withDefaultTheme and WidgetsApp', (
      tester,
    ) async {
      final app = wildnessApp(
        child: const Text('Hello Golden', textDirection: TextDirection.ltr),
        primaryColor: const Color(0xFF009688),
      );

      expect(app, isA<WildnessApp>());

      await tester.pumpWidget(app);
      expect(find.text('Hello Golden'), findsOneWidget);
    });

    testWidgets('wildnessWidgetWrapper returns functional builder', (
      tester,
    ) async {
      final wrapper = wildnessWidgetWrapper(
        primaryColor: const Color(0xFF673AB7),
      );

      final wrappedWidget = wrapper(
        const Text('Wrapped Content', textDirection: TextDirection.ltr),
      );

      await tester.pumpWidget(wrappedWidget);
      expect(find.text('Wrapped Content'), findsOneWidget);
    });
  });
}
