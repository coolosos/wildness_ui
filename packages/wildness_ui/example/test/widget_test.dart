import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui_example/main.dart';

void main() {
  testWidgets('ExampleApp renders all button and card kinds and toggles theme', (
    tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());

    // Verify header and button kinds
    expect(find.text('Wildness UI'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Secondary'), findsOneWidget);
    expect(find.text('Danger'), findsOneWidget);

    // Verify card kinds
    expect(find.text('Standard Card'), findsOneWidget);
    expect(find.text('Featured Card'), findsOneWidget);

    // Toggle theme to dark mode
    await tester.tap(find.text('🌙 Dark'));
    await tester.pumpAndSettle();

    expect(find.text('☀ Light'), findsOneWidget);
  });
}
