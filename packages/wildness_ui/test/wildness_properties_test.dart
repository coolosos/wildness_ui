import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui/wildness.dart';

base class CoolButtonThemeData extends WildnessBase<CoolButtonThemeData> {
  const CoolButtonThemeData({required this.decoration});

  final BoxDecoration? decoration;

  @override
  WildnessBase<CoolButtonThemeData> copyWith({BoxDecoration? decoration}) {
    return CoolButtonThemeData(decoration: decoration ?? this.decoration);
  }

  @override
  CoolButtonThemeData lerp(WildnessBase<CoolButtonThemeData>? other, double t) {
    if (other is! CoolButtonThemeData) {
      return this;
    }
    return CoolButtonThemeData(
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
    );
  }

  @override
  List<Object?> get props => [decoration];
}

final class CoolKindButtonThemeData extends CoolButtonThemeData {
  const CoolKindButtonThemeData({
    super.decoration = const BoxDecoration(
      color: Colors.amber,
      shape: BoxShape.rectangle,
    ),
  });
}

final class CoolButtonComponentTheme
    extends ComponentTheme<CoolButtonThemeData> {
  const CoolButtonComponentTheme({
    required super.data,
    required super.child,
    super.key,
  });

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CoolButtonComponentTheme(data: data, child: child);
  }
}

const normal = CoolButtonThemeData(
  decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.rectangle),
);
const replica = CoolButtonThemeData(
  decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.rectangle),
);

const coolKind = CoolKindButtonThemeData(
  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.rectangle),
);

base class CoolCardThemeData extends WildnessBase<CoolCardThemeData> {
  const CoolCardThemeData({required this.elevation});

  final double elevation;

  @override
  WildnessBase<CoolCardThemeData> copyWith({double? elevation}) {
    return CoolCardThemeData(elevation: elevation ?? this.elevation);
  }

  @override
  CoolCardThemeData lerp(WildnessBase<CoolCardThemeData>? other, double t) {
    if (other is! CoolCardThemeData) return this;
    return CoolCardThemeData(
      elevation: elevation + (other.elevation - elevation) * t,
    );
  }

  @override
  List<Object?> get props => [elevation];
}

class ButtonConsumer extends StatelessWidget {
  const ButtonConsumer({required this.onBuild, super.key});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    ComponentTheme.kindThemeData<CoolButtonThemeData>(context);
    return const SizedBox();
  }
}

class CardConsumer extends StatelessWidget {
  const CardConsumer({required this.onBuild, super.key});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    ComponentTheme.kindThemeData<CoolCardThemeData>(context);
    return const SizedBox();
  }
}

void main() {
  group('wildness Components', () {
    test('components size by type', () {
      const config = WildnessProperties(
        forceThemeMode: Brightness.light,
        components: Configuration(light: [normal, replica, coolKind]),
      );

      expect(config.components().length, 2);
    });
    test('components ThemeMode', () {
      const config = WildnessProperties(
        forceThemeMode: Brightness.dark,
        components: Configuration(light: [replica]),
      );

      expect(config.components().length, 0);
    });
    test('no found kind', () {
      const config = WildnessProperties(
        forceThemeMode: Brightness.dark,
        components: Configuration(light: [coolKind]),
      );

      expect(config.components()[CoolButtonThemeData], isNull);
    });
    test('found kind', () {
      const config = WildnessProperties(
        forceThemeMode: Brightness.light,
        components: Configuration(light: [coolKind]),
      );

      expect(config.components()[CoolKindButtonThemeData], isNotNull);
    });

    test('type of kind no found base', () {
      const config = WildnessProperties(
        forceThemeMode: Brightness.dark,
        components: Configuration(light: [normal]),
      );

      expect(config.components()[CoolKindButtonThemeData], isNull);
    });

    test('Configuration copyWith', () {
      const config = Configuration(light: [normal]);
      final updated = config.copyWith(dark: [replica]);

      expect(updated.light, [normal]);
      expect(updated.dark, [replica]);
    });

    test('WildnessProperties copyWith', () {
      const properties = WildnessProperties(
        forceThemeMode: Brightness.light,
        components: Configuration(light: [normal]),
      );
      final updated = properties.copyWith(
        forceThemeMode: Brightness.dark,
        minScaleFactor: 0.8,
      );

      expect(updated.forceThemeMode, Brightness.dark);
      expect(updated.minScaleFactor, 0.8);
      expect(updated.maxScaleFactor, 1.2);
    });

    testWidgets(
      'kindThemeData resolves from WildnessApp and WildnessComponentProvider override',
      (WidgetTester tester) async {
        CoolButtonThemeData? themeFromRoot;
        CoolButtonThemeData? themeFromOverride;

        const rootTheme = CoolButtonThemeData(
          decoration: BoxDecoration(color: Colors.blue),
        );
        const overriddenTheme = CoolButtonThemeData(
          decoration: BoxDecoration(color: Colors.green),
        );

        await tester.pumpWidget(
          WildnessApp(
            wildnessProperties: const WildnessProperties(
              components: Configuration(light: [rootTheme]),
            ),
            child: Builder(
              builder: (context) {
                themeFromRoot =
                    ComponentTheme.kindThemeData<CoolButtonThemeData>(context);
                return WildnessComponentProvider<CoolButtonThemeData>(
                  data: overriddenTheme,
                  child: Builder(
                    builder: (innerContext) {
                      themeFromOverride =
                          ComponentTheme.kindThemeData<CoolButtonThemeData>(
                            innerContext,
                          );
                      return const SizedBox();
                    },
                  ),
                );
              },
            ),
          ),
        );

        expect(themeFromRoot?.decoration?.color, Colors.blue);
        expect(themeFromOverride?.decoration?.color, Colors.green);
      },
    );

    testWidgets(
      'granular rebuilds: only widgets depending on changed component rebuild',
      (WidgetTester tester) async {
        var buttonBuildCount = 0;
        var cardBuildCount = 0;

        const initialButtonTheme = CoolButtonThemeData(
          decoration: BoxDecoration(color: Colors.blue),
        );
        const initialCardTheme = CoolCardThemeData(elevation: 2);

        const updatedButtonTheme = CoolButtonThemeData(
          decoration: BoxDecoration(color: Colors.red),
        );

        final configNotifier = ValueNotifier<WildnessProperties>(
          const WildnessProperties(
            components: Configuration(
              light: [initialButtonTheme, initialCardTheme],
            ),
          ),
        );

        final subtree = Column(
          children: [
            ButtonConsumer(onBuild: () => buttonBuildCount++),
            CardConsumer(onBuild: () => cardBuildCount++),
          ],
        );

        await tester.pumpWidget(
          ValueListenableBuilder<WildnessProperties>(
            valueListenable: configNotifier,
            child: subtree,
            builder: (context, properties, child) {
              return WildnessApp(wildnessProperties: properties, child: child);
            },
          ),
        );

        expect(buttonBuildCount, 1);
        expect(cardBuildCount, 1);

        // Update ONLY button theme, card theme stays identical
        configNotifier.value = const WildnessProperties(
          components: Configuration(
            light: [updatedButtonTheme, initialCardTheme],
          ),
        );
        await tester.pump();

        // Button rebuilt, but Card DID NOT rebuild!
        expect(buttonBuildCount, 2);
        expect(cardBuildCount, 1);
      },
    );

    testWidgets('wrappedThemeData resolves typed ComponentTheme', (
      WidgetTester tester,
    ) async {
      CoolButtonComponentTheme? resolvedTheme;
      const themeData = CoolButtonThemeData(
        decoration: BoxDecoration(color: Colors.cyan),
      );

      await tester.pumpWidget(
        CoolButtonComponentTheme(
          data: themeData,
          child: Builder(
            builder: (context) {
              resolvedTheme =
                  ComponentTheme.wrappedThemeData<CoolButtonComponentTheme>(
                    context,
                  );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedTheme?.data.decoration?.color, Colors.cyan);
    });
  });
}
