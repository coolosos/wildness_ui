import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui_example/main.dart';

void main() {
  testWidgets('ExampleApp renders and toggles theme mode without Material dependencies', (
    tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.text('Wildness UI'), findsOneWidget);
    expect(find.text('Standard Component'), findsOneWidget);
    expect(find.text('Overridden Accent Theme'), findsOneWidget);
    expect(find.text('Custom ComponentTheme Wrapper'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);

    // Toggle theme to dark mode via pure WildButton
    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();

    expect(find.text('Light Mode'), findsOneWidget);
  });
}
