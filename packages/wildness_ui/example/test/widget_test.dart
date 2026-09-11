import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui/wildness.dart';
import 'package:wildness_ui_example/main.dart';

void main() {
  testWidgets('ExampleApp renders 1 component with 2 kinds and toggles theme', (
    tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());

    // Verify header and button kinds rendered from WildButton
    expect(find.text('Wildness UI'), findsOneWidget);
    expect(find.text('Primary Button'), findsOneWidget);
    expect(find.text('Secondary Button'), findsOneWidget);

    // Toggle theme to dark mode
    await tester.tap(find.text('🌙 Switch to Dark Mode'));
    await tester.pumpAndSettle();

    expect(find.text('☀ Switch to Light Mode'), findsOneWidget);
  });

  test('ButtonThemeData copyWith, lerp, and props operate correctly', () {
    const primary = PrimaryButtonThemeData(
      backgroundColor: Color(0xFF2563EB),
      textColor: Color(0xFFFFFFFF),
    );

    // Test copyWith
    final copied = primary.copyWith(textColor: const Color(0xFF000000));
    expect(copied.textColor, const Color(0xFF000000));
    expect(copied.backgroundColor, const Color(0xFF2563EB));

    // Test lerp
    const target = PrimaryButtonThemeData(
      backgroundColor: Color(0xFF000000),
      textColor: Color(0xFF000000),
      borderRadius: 16,
    );
    final lerped = primary.lerp(target, 0.5);
    expect(lerped.borderRadius, 12);

    // Lerp with null returns this
    expect(primary.lerp(null, 0.5), equals(primary));

    // Test equality via props
    const primarySame = PrimaryButtonThemeData(
      backgroundColor: Color(0xFF2563EB),
      textColor: Color(0xFFFFFFFF),
    );
    expect(primary, equals(primarySame));
  });
}
