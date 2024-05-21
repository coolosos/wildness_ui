part of "../wildness_ui_golden_toolkit.dart";

@isTest
void testColumnComponent({
  required String name,
  required List<Component> scenarios,
  String? groupName,
  Future<TestGesture?> Function(WidgetTester tester)? gestureBuilder,
  List<Device>? devices,
  Size surfaceSize = const Size(800, 740),
  Key? touchKey,
  Widget Function(Widget child)? wrap,
  bool? autoHeight = true,
  double? textScaleSize,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
}) {
  testGoldens(name, (WidgetTester tester) async {
    final builder = GoldenBuilder.column(wrap: wrap);

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

        await gestureBuilder?.call(tester);
      },
      autoHeight: autoHeight,
      config: config,
      defaultTextStyle: defaultTextStyle,
      localizationsDelegates: localizationsDelegates,
      primaryColor: primaryColor,
      supportedLocales: supportedLocales,
      textScaleSize: textScaleSize,
    );
  });
}

@isTest
void testDeviceComponent({
  required String name,
  required List<Component> scenarios,
  String? groupName,
  Future<TestGesture?> Function(WidgetTester tester)? gestureBuilder,
  List<Device>? devices,
  Size surfaceSize = const Size(800, 740),
  Key? touchKey,
  Widget Function(Widget child)? wrap,
  bool? autoHeight = true,
  double? textScaleSize,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
}) {
  testGoldens(name, (WidgetTester tester) async {
    final builder = DeviceBuilder(wrap: wrap);
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
      config: config,
      defaultTextStyle: defaultTextStyle,
      localizationsDelegates: localizationsDelegates,
      primaryColor: primaryColor,
      supportedLocales: supportedLocales,
      gestureBuilder: () async {
        if (touchKey != null) {
          await tester.startGesture(
            tester.getRect(find.byKey(touchKey)).center,
          );
        }

        await gestureBuilder?.call(tester);
      },
    );
  });
}
