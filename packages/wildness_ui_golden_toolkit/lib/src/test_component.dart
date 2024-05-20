part of "../wildness_ui_golden_toolkit.dart";

@isTest
void testColumnComponent({
  required String name,
  required List<Component> scenarios,
  String? groupName,
  Future<TestGesture?> Function()? gestureBuilder,
  List<Device>? devices,
  Size surfaceSize = const Size(800, 740),
  Key? touchKey,
}) {
  testGoldens(name, (WidgetTester tester) async {
    final builder = GoldenBuilder.column();

    for (var scenario in scenarios) {
      if (scenario.textScaleFactor != null) {
        builder.addTextScaleScenario(
          scenario.name,
          scenario.widget,
          textScaleFactor:
              scenario.textScaleFactor ?? textScaleFactorMaxSupported,
        );
      } else {
        builder.addScenario(scenario.name, scenario.widget);
      }
    }

    await tester.pumpWidgetAndMatchWithGesture(
      groupTitle: 'components/${(groupName ?? name).toLowerCase()}',
      builder: builder,
      surfaceSize: surfaceSize,
      gestureBuilder: () async {
        if (touchKey != null) {
          await tester.startGesture(
            tester.getRect(find.byKey(touchKey)).center,
          );
        }

        await gestureBuilder?.call();
      },
    );
  });
}

@isTest
void testDeviceComponent({
  required String name,
  required List<Component> scenarios,
  String? groupName,
  Future<TestGesture?> Function()? gestureBuilder,
  List<Device>? devices,
  Size surfaceSize = const Size(800, 740),
  Key? touchKey,
}) {
  testGoldens(name, (WidgetTester tester) async {
    final builder = DeviceBuilder();
    if (devices != null) {
      builder.overrideDevicesForAllScenarios(devices: devices);
    }

    for (var scenario in scenarios) {
      builder.addScenario(
        name: scenario.name,
        widget: scenario.widget,
      );
    }

    await tester.pumpDeviceAndMatch(
      groupTitle: 'components/${(groupName ?? name).toLowerCase()}',
      builder: builder,
      autoHeight: true,
    );
  });
}
