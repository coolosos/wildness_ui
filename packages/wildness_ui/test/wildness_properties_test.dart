import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui/wildness.dart';

base class CoolButtonThemeData extends WildnessBase<CoolButtonThemeData> {
  const new({required this.decoration});

  final BoxDecoration? decoration;

  @override
  WildnessBase<CoolButtonThemeData> copyWith({BoxDecoration? decoration}) {
    return CoolButtonThemeData(decoration: decoration ?? this.decoration);
  }

  @override
  CoolButtonThemeData lerp(WildnessBase<CoolButtonThemeData>? other, double t) {
    if (other is! CoolButtonThemeData) return this;
    return CoolButtonThemeData(
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
    );
  }

  @override
  List<Object?> get props => [decoration];
}

final class CoolKindButtonThemeData extends CoolButtonThemeData {
  const new({
    super.decoration = const BoxDecoration(
      color: Colors.amber,
      shape: BoxShape.rectangle,
    ),
  });
}

final class CoolButtonComponentTheme
    extends ComponentTheme<CoolButtonThemeData> {
  const new({required super.data, required super.child, super.key});

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CoolButtonComponentTheme(data: data, child: child);
  }
}

base class CoolCardThemeData extends WildnessBase<CoolCardThemeData> {
  const new({required this.elevation});

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

base class CoolResourceData extends WildnessBase<CoolResourceData> {
  const new({required this.endpoint});

  final String endpoint;

  @override
  CoolResourceData copyWith({String? endpoint}) {
    return CoolResourceData(endpoint: endpoint ?? this.endpoint);
  }

  @override
  CoolResourceData lerp(WildnessBase<CoolResourceData>? other, double t) {
    if (other is! CoolResourceData) return this;
    return t < 0.5 ? this : other;
  }

  @override
  List<Object?> get props => [endpoint];
}

class ButtonConsumer extends StatelessWidget {
  const new({required this.onBuild, super.key});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    ComponentTheme.kindThemeData<CoolButtonThemeData>(context);
    return const SizedBox.shrink();
  }
}

class CardConsumer extends StatelessWidget {
  const new({required this.onBuild, super.key});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    ComponentTheme.kindThemeData<CoolCardThemeData>(context);
    return const SizedBox.shrink();
  }
}

const normalButton = CoolButtonThemeData(
  decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.rectangle),
);
const replicaButton = CoolButtonThemeData(
  decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.rectangle),
);
const kindButton = CoolKindButtonThemeData(
  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.rectangle),
);

const resourceLight = CoolResourceData(endpoint: 'https://api.light.example');
const resourceDark = CoolResourceData(endpoint: 'https://api.dark.example');

void main() {
  group('Configuration', () {
    test('default constructor initializes empty iterables', () {
      const config = Configuration();
      expect(config.light, isEmpty);
      expect(config.dark, isEmpty);
    });

    test('copyWith updates light and dark collections independently', () {
      const config = Configuration(light: [normalButton]);
      final updated = config.copyWith(dark: [replicaButton]);

      expect(updated.light, [normalButton]);
      expect(updated.dark, [replicaButton]);
    });

    test('fromComponents and fromResources instantiate configurations cleanly', () {
      const componentsLight = _TestComponents(componentsList: [normalButton]);
      const componentsDark = _TestComponents(componentsList: [replicaButton]);
      const resourcesLight = _TestResources(resourcesList: [resourceLight]);
      const resourcesDark = _TestResources(resourcesList: [resourceDark]);

      final configComponents = Configuration.fromComponents(
        light: componentsLight,
        dark: componentsDark,
      );
      final configResources = Configuration.fromResources(
        light: resourcesLight,
        dark: resourcesDark,
      );

      expect(configComponents.light, [normalButton]);
      expect(configComponents.dark, [replicaButton]);
      expect(configResources.light, [resourceLight]);
      expect(configResources.dark, [resourceDark]);
    });
  });

  group('WildnessProperties', () {
    test('fromTheme instantiates components and resources cleanly', () {
      const componentsLight = _TestComponents(componentsList: [normalButton]);
      const resourcesLight = _TestResources(resourcesList: [resourceLight]);

      final props = WildnessProperties.fromTheme(
        lightComponents: componentsLight,
        lightResources: resourcesLight,
      );

      expect(props.components()[CoolButtonThemeData], normalButton);
      expect(props.resources()[CoolResourceData], resourceLight);
    });
    test('components size and deduplication by type', () {
      const properties = WildnessProperties(
        forceThemeMode: Brightness.light,
        components: Configuration(light: [normalButton, replicaButton, kindButton]),
      );

      // normalButton and replicaButton share CoolButtonThemeData runtimeType, kindButton has CoolKindButtonThemeData
      expect(properties.components().length, 2);
    });

    test('components resolves according to themeMode, forceThemeMode, and explicit brightness', () {
      const properties = WildnessProperties(
        components: Configuration(
          light: [normalButton],
          dark: [replicaButton],
        ),
      );

      // Default (no forceThemeMode, no brightness) -> light
      expect(properties.components()[CoolButtonThemeData], normalButton);

      // Explicit brightness overrides
      expect(
        properties.components(brightness: Brightness.dark)[CoolButtonThemeData],
        replicaButton,
      );
      expect(
        properties.components(brightness: Brightness.light)[CoolButtonThemeData],
        normalButton,
      );

      // Forced dark mode
      final forcedDark = properties.copyWith(forceThemeMode: Brightness.dark);
      expect(forcedDark.components()[CoolButtonThemeData], replicaButton);
    });

    test('resources resolves according to themeMode, forceThemeMode, and explicit brightness', () {
      const properties = WildnessProperties(
        resources: Configuration(
          light: [resourceLight],
          dark: [resourceDark],
        ),
      );

      // Default (no forceThemeMode, no brightness) -> light
      expect(properties.resources()[CoolResourceData], resourceLight);

      // Explicit brightness overrides
      expect(
        properties.resources(brightness: Brightness.dark)[CoolResourceData],
        resourceDark,
      );
      expect(
        properties.resources(brightness: Brightness.light)[CoolResourceData],
        resourceLight,
      );

      // Forced dark mode
      final forcedDark = properties.copyWith(forceThemeMode: Brightness.dark);
      expect(forcedDark.resources()[CoolResourceData], resourceDark);
    });

    test('copyWith updates all properties cleanly', () {
      const properties = WildnessProperties(
        forceThemeMode: Brightness.light,
        components: Configuration(light: [normalButton]),
        resources: Configuration(light: [resourceLight]),
        minScaleFactor: 0.6,
        maxScaleFactor: 1.4,
      );

      final updated = properties.copyWith(
        forceThemeMode: Brightness.dark,
        components: const Configuration(light: [replicaButton]),
        resources: const Configuration(dark: [resourceDark]),
        physics: const BouncingScrollPhysics(),
        minScaleFactor: 0.8,
        maxScaleFactor: 1.6,
      );

      expect(updated.forceThemeMode, Brightness.dark);
      expect(updated.physics, const BouncingScrollPhysics());
      expect(updated.minScaleFactor, 0.8);
      expect(updated.maxScaleFactor, 1.6);
      expect(updated.components(brightness: Brightness.light)[CoolButtonThemeData], replicaButton);
      expect(updated.resources()[CoolResourceData], resourceDark);
    });
  });

  group('WildnessBase and ComponentTheme', () {
    test('WildnessBase name, type and wrapProvider', () {
      const button = normalButton;
      expect(button.name, 'CoolButtonThemeData');
      expect(button.type, CoolButtonThemeData);

      final provider = button.wrapProvider(child: const SizedBox.shrink());
      expect(provider, isA<WildnessComponentProvider<CoolButtonThemeData>>());
    });

    testWidgets(
      'kindThemeData falls back to WildnessProvider when no WildnessComponentProvider exists',
      (tester) async {
        CoolButtonThemeData? resolvedButton;

        await tester.pumpWidget(
          WildnessProvider(
            data: const Wildness(
              physics: ClampingScrollPhysics(),
              components: {CoolButtonThemeData: normalButton},
            ),
            child: Builder(
              builder: (context) {
                resolvedButton =
                    ComponentTheme.kindThemeData<CoolButtonThemeData>(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedButton, normalButton);
      },
    );

    test('ComponentTheme type and updateShouldNotify', () {
      const theme1 = CoolButtonComponentTheme(
        data: normalButton,
        child: SizedBox.shrink(),
      );
      const theme2 = CoolButtonComponentTheme(
        data: normalButton,
        child: SizedBox.shrink(),
      );
      const theme3 = CoolButtonComponentTheme(
        data: replicaButton,
        child: SizedBox.shrink(),
      );

      expect(theme1.type, CoolButtonThemeData);
      expect(theme1.updateShouldNotify(theme2), isFalse);
      expect(theme1.updateShouldNotify(theme3), isTrue);
    });

    testWidgets(
      'kindThemeData resolves from WildnessApp and WildnessComponentProvider override',
      (tester) async {
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
                      return const SizedBox.shrink();
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
      (tester) async {
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
      tester,
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
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedTheme?.data.decoration?.color, Colors.cyan);
    });

    testWidgets(
      'resolves base default theme and polymorphic subtypes correctly without shadowing',
      (tester) async {
        const defaultButton = CoolButtonThemeData(
          decoration: BoxDecoration(color: Colors.grey),
        );
        const specializedButton = CoolKindButtonThemeData(
          decoration: BoxDecoration(color: Colors.purple),
        );

        CoolButtonThemeData? resolvedDefault;
        CoolKindButtonThemeData? resolvedSpecialized;

        const components = _TestComponents(
          componentsList: [specializedButton, defaultButton],
        );

        await tester.pumpWidget(
          WildnessApp(
            wildnessProperties: WildnessProperties.fromComponents(
              light: components,
            ),
            child: Builder(
              builder: (context) {
                resolvedDefault =
                    ComponentTheme.kindThemeData<CoolButtonThemeData>(context);
                resolvedSpecialized =
                    ComponentTheme.kindThemeData<CoolKindButtonThemeData>(
                      context,
                    );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        // Base type resolution gets defaultButton, NOT specializedButton (no shadowing!)
        expect(resolvedDefault?.decoration?.color, Colors.grey);
        // Subtype resolution gets specializedButton
        expect(resolvedSpecialized?.decoration?.color, Colors.purple);
      },
    );

    testWidgets('componentByName and componentByNameCast resolve from ComponentTheme', (
      tester,
    ) async {
      WildnessBase<dynamic>? byNameRoot;
      CoolButtonThemeData? byNameCastRoot;
      CoolButtonThemeData? byNameCastOverridden;

      const rootButton = CoolButtonThemeData(
        decoration: BoxDecoration(color: Colors.blue),
      );
      const overrideButton = CoolButtonThemeData(
        decoration: BoxDecoration(color: Colors.green),
      );

      await tester.pumpWidget(
        WildnessApp(
          wildnessProperties: const WildnessProperties(
            components: Configuration(light: [rootButton]),
          ),
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  byNameRoot = ComponentTheme.componentByName(
                    context,
                    'CoolButtonThemeData',
                  );
                  byNameCastRoot =
                      ComponentTheme.componentByNameCast<CoolButtonThemeData>(
                        context,
                        'CoolButtonThemeData',
                      );
                  return const SizedBox.shrink();
                },
              ),
              WildnessComponentProvider<CoolButtonThemeData>(
                data: overrideButton,
                child: Builder(
                  builder: (innerContext) {
                    byNameCastOverridden =
                        ComponentTheme.componentByNameCast<CoolButtonThemeData>(
                          innerContext,
                          'CoolButtonThemeData',
                        );
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );

      expect(byNameRoot, rootButton);
      expect(byNameCastRoot?.decoration?.color, Colors.blue);
      expect(byNameCastOverridden?.decoration?.color, Colors.green);
    });
  });
}

class _TestComponents extends Components {
  const new({required this.componentsList});
  final List<WildnessBase<dynamic>> componentsList;

  @override
  List<WildnessBase<dynamic>> get components => componentsList;
}

class _TestResources extends Resources {
  const new({required this.resourcesList});
  final List<WildnessBase<dynamic>> resourcesList;

  @override
  List<WildnessBase<dynamic>> get resources => resourcesList;
}
