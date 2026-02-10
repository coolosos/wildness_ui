part of '../wildness_ui_golden_toolkit.dart';

@isTest
void testColumnComponent({
  required String name,
  required List<Component> scenarios,
  String? groupName,
  Future<TestGesture?> Function(WidgetTester tester)? gestureBuilder,
  Size surfaceSize = const Size(800, 740),
  Key? touchKey,
  Widget Function(Widget child)? wrap,
  bool autoHeight = true,
  double? textScaleSize,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
}) {
  testWidgets(name, (tester) async {
    final content = Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: scenarios.map((scenario) {
          var child = scenario.widget;

          final factor = scenario.textScaleFactor;
          if (factor != null) {
            child = MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(
                  factor.clamp(1.0, textScaleFactorMaxSupported),
                ),
              ),
              child: child,
            );
          }

          final scenarioWidget = SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    scenario.name +
                        ((factor != null) ? ' (textScale: $factor)' : ''),
                  ),
                ),
                const SizedBox(height: 8),
                Center(child: child),
                const SizedBox(height: 24),
              ],
            ),
          );

          return wrap != null ? wrap(scenarioWidget) : scenarioWidget;
        }).toList(),
      ),
    );

    await tester.pumpWidgetAndMatch(
      widget: content,
      groupTitle: 'components/${(groupName ?? name).toLowerCase()}',
      surfaceSize: surfaceSize,
      autoHeight: autoHeight,
      gestureBuilder: () async {
        if (touchKey != null) {
          await tester.startGesture(
            tester.getRect(find.byKey(touchKey)).center,
          );
        }
        await gestureBuilder?.call(tester);
      },
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      config: config,
      defaultTextStyle: defaultTextStyle,
      primaryColor: primaryColor,
    );
  }, tags: ['golden']);
}

@isTest
void testDeviceComponent({
  required String name,
  required List<Component> scenarios,
  String? groupName,
  List<TestDevice>? devices,
  Future<TestGesture?> Function(WidgetTester tester)? gestureBuilder,
  Key? touchKey,
  Widget Function(Widget child)? wrap,
  bool autoHeight = true,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
}) {
  final resolvedDevices = devices ?? Devices.common;

  for (final device in resolvedDevices) {
    testWidgets('$name – ${device.name}', (tester) async {
      final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: scenarios.map((s) {
          final widget = wrap != null ? wrap(s.widget) : s.widget;
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: widget,
          );
        }).toList(),
      );

      await tester.pumpDeviceAndMatch(
        device: device,
        widget: content,
        groupTitle:
            'components/${(groupName ?? name).toLowerCase()}_${device.name.toLowerCase()}',
        autoHeight: autoHeight,
        gestureBuilder: () async {
          if (touchKey != null) {
            await tester.startGesture(
              tester.getRect(find.byKey(touchKey)).center,
            );
          }
          await gestureBuilder?.call(tester);
        },
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        config: config,
        defaultTextStyle: defaultTextStyle,
        primaryColor: primaryColor,
      );
    }, tags: ['golden']);
  }
}
