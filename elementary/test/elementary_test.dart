import 'package:elementary/elementary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elementary/library.dart';

void main() {
  group('Widtget', () {
    testWidgets('Verify only one DefaultTestStyle',
        (WidgetTester tester) async {
      const config = ElementaryProperties(
        forzeThemeMode: Brightness.dark,
      );
      const app = ElementaryApp(
        elementaryProperties: config,
        defaultTextStyle: TextStyle(fontFamily: 'test'),
      );

      await tester.pumpWidget(app);

      var fab = find.byType(DefaultTextStyle);

      expect(fab, findsOneWidget);
    });

    testWidgets('Verify only one DefaultTestStyle',
        (WidgetTester tester) async {
      const config = ElementaryProperties(
        forzeThemeMode: Brightness.dark,
        // TextStyle(fontFamily: 'test')
      );
      String? fontFamily;
      final app = ElementaryApp(
        elementaryProperties: config,
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
  });
}
