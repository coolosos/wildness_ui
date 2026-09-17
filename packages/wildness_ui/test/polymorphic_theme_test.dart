import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui/wildness.dart';

// =============================================================================
// Generic Polymorphic Theme Hierarchy
// =============================================================================

base class CardThemeData extends WildnessBase<CardThemeData> {
  const new({
    this.backgroundColor = Colors.white,
    this.elevation = 0.0,
    this.title = 'DefaultCardTheme',
  });

  final Color backgroundColor;
  final double elevation;
  final String title;

  @override
  CardThemeData copyWith({
    Color? backgroundColor,
    double? elevation,
    String? title,
  }) {
    return CardThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      title: title ?? this.title,
    );
  }

  @override
  CardThemeData lerp(WildnessBase<CardThemeData>? other, double t) {
    if (other is! CardThemeData) return this;
    return CardThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      elevation: elevation + (other.elevation - elevation) * t,
      title: t < 0.5 ? title : other.title,
    );
  }

  @override
  List<Object?> get props => [backgroundColor, elevation, title];
}

final class ElevatedCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.blue,
    super.elevation = 1.0,
    super.title = 'ElevatedCardThemeData',
  });
}

final class OutlinedCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.green,
    super.elevation = 2.0,
    super.title = 'OutlinedCardThemeData',
  });
}

final class SuccessCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.orange,
    super.elevation = 3.0,
    super.title = 'SuccessCardThemeData',
  });
}

final class WarningCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.purple,
    super.elevation = 4.0,
    super.title = 'WarningCardThemeData',
  });
}

final class InfoCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.cyan,
    super.elevation = 5.0,
    super.title = 'InfoCardThemeData',
  });
}

final class ShadowsCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.grey,
    super.elevation = 6.0,
    super.title = 'ShadowsCardThemeData',
  });
}

final class ErrorCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.red,
    super.elevation = 7.0,
    super.title = 'ErrorCardThemeData',
  });
}

final class AccentCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.teal,
    super.elevation = 8.0,
    super.title = 'AccentCardThemeData',
  });
}

final class MinimalCardThemeData extends CardThemeData {
  const new({
    super.backgroundColor = Colors.indigo,
    super.elevation = 9.0,
    super.title = 'MinimalCardThemeData',
  });
}

// Second component family
base class CustomButtonThemeData extends WildnessBase<CustomButtonThemeData> {
  const new({this.color = Colors.black});
  final Color color;

  @override
  CustomButtonThemeData copyWith({Color? color}) {
    return CustomButtonThemeData(color: color ?? this.color);
  }

  @override
  CustomButtonThemeData lerp(
    WildnessBase<CustomButtonThemeData>? other,
    double t,
  ) {
    if (other is! CustomButtonThemeData) return this;
    return CustomButtonThemeData(
      color: Color.lerp(color, other.color, t) ?? color,
    );
  }

  @override
  List<Object?> get props => [color];
}

// =============================================================================
// Generic Components Aggregation
// =============================================================================

class CardComponents extends Components {
  const new({
    required this.elevatedCard,
    required this.outlinedCard,
    required this.successCard,
    required this.warningCard,
    required this.defaultCard,
    required this.shadowsCard,
    required this.errorCard,
    required this.accentCard,
    required this.infoCard,
    required this.minimalCard,
  });

  final ElevatedCardThemeData elevatedCard;
  final OutlinedCardThemeData outlinedCard;
  final SuccessCardThemeData warningCard;
  final WarningCardThemeData successCard;
  final CardThemeData defaultCard;
  final ShadowsCardThemeData shadowsCard;
  final ErrorCardThemeData errorCard;
  final AccentCardThemeData accentCard;
  final InfoCardThemeData infoCard;
  final MinimalCardThemeData minimalCard;

  @override
  List<WildnessBase<dynamic>> get components => [
        elevatedCard, // index 0 (subtype, NOT default)
        outlinedCard,
        warningCard,
        successCard,
        defaultCard, // index 4 (base default CardThemeData)
        shadowsCard,
        errorCard,
        accentCard,
        infoCard,
        minimalCard,
      ];
}

class AppComponents extends Components {
  const new({required this.cards, required this.buttonTheme});

  final CardComponents cards;
  final CustomButtonThemeData buttonTheme;

  @override
  List<WildnessBase<dynamic>> get components => [
        ...cards.components,
        buttonTheme,
      ];
}

// Consumers to verify granular rebuilds
class DefaultCardConsumer extends StatelessWidget {
  const new({required this.onBuild, super.key});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    ComponentTheme.kindThemeData<CardThemeData>(context);
    return const SizedBox.shrink();
  }
}

class ElevatedCardConsumer extends StatelessWidget {
  const new({required this.onBuild, super.key});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    ComponentTheme.kindThemeData<ElevatedCardThemeData>(context);
    return const SizedBox.shrink();
  }
}

class CustomButtonConsumer extends StatelessWidget {
  const new({required this.onBuild, super.key});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    ComponentTheme.kindThemeData<CustomButtonThemeData>(context);
    return const SizedBox.shrink();
  }
}

// =============================================================================
// Tests
// =============================================================================

void main() {
  group('Polymorphic Themes & Multi-Variant Builder', () {
    const cardComponents = CardComponents(
      elevatedCard: ElevatedCardThemeData(),
      outlinedCard: OutlinedCardThemeData(),
      warningCard: SuccessCardThemeData(),
      successCard: WarningCardThemeData(),
      defaultCard: CardThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        title: 'DefaultCardTheme',
      ),
      shadowsCard: ShadowsCardThemeData(),
      errorCard: ErrorCardThemeData(),
      accentCard: AccentCardThemeData(),
      infoCard: InfoCardThemeData(),
      minimalCard: MinimalCardThemeData(),
    );

    const appComponents = AppComponents(
      cards: cardComponents,
      buttonTheme: CustomButtonThemeData(color: Colors.black),
    );

    testWidgets(
      'resolves defaultCard when querying base CardThemeData regardless of list order',
      (tester) async {
        CardThemeData? resolvedDefault;
        ElevatedCardThemeData? resolvedElevated;
        InfoCardThemeData? resolvedInfo;
        ErrorCardThemeData? resolvedError;
        MinimalCardThemeData? resolvedMinimal;
        CustomButtonThemeData? resolvedButton;

        await tester.pumpWidget(
          WildnessApp(
            wildnessProperties: WildnessProperties.fromComponents(
              light: appComponents,
            ),
            child: Builder(
              builder: (context) {
                resolvedDefault =
                    ComponentTheme.kindThemeData<CardThemeData>(context);
                resolvedElevated =
                    ComponentTheme.kindThemeData<ElevatedCardThemeData>(context);
                resolvedInfo =
                    ComponentTheme.kindThemeData<InfoCardThemeData>(context);
                resolvedError =
                    ComponentTheme.kindThemeData<ErrorCardThemeData>(context);
                resolvedMinimal =
                    ComponentTheme.kindThemeData<MinimalCardThemeData>(context);
                resolvedButton =
                    ComponentTheme.kindThemeData<CustomButtonThemeData>(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        // 1. Base type resolution returns the default, NOT ElevatedCardThemeData (which was index 0)
        expect(resolvedDefault, isNotNull);
        expect(resolvedDefault?.title, 'DefaultCardTheme');
        expect(resolvedDefault?.backgroundColor, Colors.white);
        expect(resolvedDefault?.elevation, 0.0);

        // 2. Subtypes resolve accurately to their specific instances
        expect(resolvedElevated?.title, 'ElevatedCardThemeData');
        expect(resolvedElevated?.backgroundColor, Colors.blue);

        expect(resolvedInfo?.title, 'InfoCardThemeData');
        expect(resolvedInfo?.backgroundColor, Colors.cyan);

        expect(resolvedError?.title, 'ErrorCardThemeData');
        expect(resolvedError?.backgroundColor, Colors.red);

        expect(resolvedMinimal?.title, 'MinimalCardThemeData');
        expect(resolvedMinimal?.backgroundColor, Colors.indigo);

        expect(resolvedButton?.color, Colors.black);
      },
    );

    testWidgets(
      'granular rebuilds: only the specific changed variant or base component rebuilds',
      (tester) async {
        var defaultBuildCount = 0;
        var elevatedBuildCount = 0;
        var buttonBuildCount = 0;

        final propertiesNotifier = ValueNotifier<WildnessProperties>(
          WildnessProperties.fromComponents(light: appComponents),
        );

        final testTree = Column(
          children: [
            DefaultCardConsumer(onBuild: () => defaultBuildCount++),
            ElevatedCardConsumer(onBuild: () => elevatedBuildCount++),
            CustomButtonConsumer(onBuild: () => buttonBuildCount++),
          ],
        );

        await tester.pumpWidget(
          ValueListenableBuilder<WildnessProperties>(
            valueListenable: propertiesNotifier,
            child: testTree,
            builder: (context, properties, child) {
              return WildnessApp(wildnessProperties: properties, child: child);
            },
          ),
        );

        expect(defaultBuildCount, 1);
        expect(elevatedBuildCount, 1);
        expect(buttonBuildCount, 1);

        // 1. Update ONLY defaultCard
        const updatedCards1 = CardComponents(
          elevatedCard: ElevatedCardThemeData(),
          outlinedCard: OutlinedCardThemeData(),
          warningCard: SuccessCardThemeData(),
          successCard: WarningCardThemeData(),
          defaultCard: CardThemeData(
            backgroundColor: Colors.yellow,
            title: 'UpdatedDefaultCard',
          ),
          shadowsCard: ShadowsCardThemeData(),
          errorCard: ErrorCardThemeData(),
          accentCard: AccentCardThemeData(),
          infoCard: InfoCardThemeData(),
          minimalCard: MinimalCardThemeData(),
        );

        propertiesNotifier.value = WildnessProperties.fromComponents(
          light: const AppComponents(
            cards: updatedCards1,
            buttonTheme: CustomButtonThemeData(color: Colors.black),
          ),
        );
        await tester.pump();

        // DefaultCard rebuilt, ElevatedCard & Button DID NOT rebuild
        expect(defaultBuildCount, 2);
        expect(elevatedBuildCount, 1);
        expect(buttonBuildCount, 1);

        // 2. Update ONLY ElevatedCardThemeData
        const updatedCards2 = CardComponents(
          elevatedCard: ElevatedCardThemeData(
            backgroundColor: Colors.deepPurple,
            title: 'UpdatedElevatedCard',
          ),
          outlinedCard: OutlinedCardThemeData(),
          warningCard: SuccessCardThemeData(),
          successCard: WarningCardThemeData(),
          defaultCard: CardThemeData(
            backgroundColor: Colors.yellow,
            title: 'UpdatedDefaultCard',
          ),
          shadowsCard: ShadowsCardThemeData(),
          errorCard: ErrorCardThemeData(),
          accentCard: AccentCardThemeData(),
          infoCard: InfoCardThemeData(),
          minimalCard: MinimalCardThemeData(),
        );

        propertiesNotifier.value = WildnessProperties.fromComponents(
          light: const AppComponents(
            cards: updatedCards2,
            buttonTheme: CustomButtonThemeData(color: Colors.black),
          ),
        );
        await tester.pump();

        // ElevatedCard rebuilt, DefaultCard & Button DID NOT rebuild
        expect(defaultBuildCount, 2);
        expect(elevatedBuildCount, 2);
        expect(buttonBuildCount, 1);

        // 3. Update ONLY ButtonTheme
        propertiesNotifier.value = WildnessProperties.fromComponents(
          light: const AppComponents(
            cards: updatedCards2,
            buttonTheme: CustomButtonThemeData(color: Colors.pink),
          ),
        );
        await tester.pump();

        // Button rebuilt, DefaultCard & ElevatedCard DID NOT rebuild
        expect(defaultBuildCount, 2);
        expect(elevatedBuildCount, 2);
        expect(buttonBuildCount, 2);
      },
    );

    testWidgets(
      'local WildnessComponentProvider override in subtree does not corrupt global default',
      (tester) async {
        CardThemeData? globalDefaultTheme;
        CardThemeData? localOverriddenTheme;
        CardThemeData? siblingDefaultTheme;

        const localOverride = CardThemeData(
          backgroundColor: Colors.amber,
          title: 'LocalOverrideTheme',
        );

        await tester.pumpWidget(
          WildnessApp(
            wildnessProperties: WildnessProperties.fromComponents(
              light: appComponents,
            ),
            child: Column(
              children: [
                // Global context
                Builder(
                  builder: (context) {
                    globalDefaultTheme =
                        ComponentTheme.kindThemeData<CardThemeData>(context);
                    return const SizedBox.shrink();
                  },
                ),
                // Subtree with local override
                WildnessComponentProvider<CardThemeData>(
                  data: localOverride,
                  child: Builder(
                    builder: (innerContext) {
                      localOverriddenTheme =
                          ComponentTheme.kindThemeData<CardThemeData>(
                            innerContext,
                          );
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                // Sibling subtree (must still get global default)
                Builder(
                  builder: (siblingContext) {
                    siblingDefaultTheme =
                        ComponentTheme.kindThemeData<CardThemeData>(
                          siblingContext,
                        );
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );

        expect(globalDefaultTheme?.title, 'DefaultCardTheme');
        expect(localOverriddenTheme?.title, 'LocalOverrideTheme');
        expect(siblingDefaultTheme?.title, 'DefaultCardTheme');
      },
    );
  });
}
