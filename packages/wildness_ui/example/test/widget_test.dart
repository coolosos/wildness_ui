import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui_example/main.dart';

void main() {
  testWidgets('ExampleApp renders and toggles theme mode', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.text('Wildness UI Design System'), findsOneWidget);
    expect(find.text('Standard Wildness Card'), findsOneWidget);
    expect(find.text('Overridden Accent Card'), findsOneWidget);
    expect(find.text('Inherited Wrapped Card'), findsOneWidget);

    // Toggle theme to dark mode
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });
}
