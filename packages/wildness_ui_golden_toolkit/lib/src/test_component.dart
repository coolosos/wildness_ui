part of '../wildness_ui_golden_toolkit.dart';

@isTest
void testColumnComponent({
  required String name,
  required List<Component> scenarios,
  String? groupName,
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
    final content = ColoredBox(
      color: const Color(0xFFEEEEEE),
      child: Padding(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      scenario.name +
                          ((scenario.textScaleFactor != null)
                              ? ' ${scenario.textScaleFactor}'
                              : ''),
                    ),
                  ),
                  const SizedBox(height: 8),
                  child,
                  const SizedBox(height: 24),
                ],
              ),
            );

            return wrap != null ? wrap(scenarioWidget) : scenarioWidget;
          }).toList(),
        ),
      ),
    );

    await tester.pumpWidgetAndMatch(
      widget: content,
      groupTitle: 'components/${(groupName ?? name).toLowerCase()}',
      surfaceSize: surfaceSize,
      autoHeight: autoHeight,
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
  final resolvedDevices = devices ?? Devices.all;

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
            'components/$groupName/${(groupName ?? name).toLowerCase()}_${device.name.toLowerCase()}',
        autoHeight: autoHeight,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        config: config,
        defaultTextStyle: defaultTextStyle,
        primaryColor: primaryColor,
      );
    }, tags: ['golden']);
  }
}

@isTest
void testDevicesGolden({
  required String name,
  required List<Component> scenarios,
  String? groupName,
  List<TestDevice>? devices,
  Axis direction = Axis.horizontal, // Row o Column
  Widget Function(Widget child)? wrap,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
}) {
  final resolvedDevices = devices ?? Devices.all;

  testWidgets(name, (tester) async {
    final deviceWidgets = resolvedDevices.map((device) {
      return _DeviceScenarioView(
        device: device,
        scenarios: scenarios,
        wrap: wrap,
      );
    }).toList();

    final content = ColoredBox(
      color: const Color(0xFFEEEEEE),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: direction == Axis.horizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: deviceWidgets,
              )
            : Column(children: deviceWidgets),
      ),
    );

    await tester.pumpWidgetAndMatch(
      widget: content,
      groupTitle: 'components/${(groupName ?? name).toLowerCase()}',
      surfaceSize: _calculateSurface(resolvedDevices, direction),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      config: config,
      defaultTextStyle: defaultTextStyle,
      primaryColor: primaryColor,
    );
  }, tags: ['golden']);
}

class _DeviceScenarioView extends StatelessWidget {
  const _DeviceScenarioView({
    required this.device,
    required this.scenarios,
    this.wrap,
  });

  final TestDevice device;
  final List<Component> scenarios;
  final Widget Function(Widget child)? wrap;

  @override
  Widget build(BuildContext context) {
    final Widget scenarioColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...scenarios.map((scenario) {
          var child = scenario.widget;

          if (wrap != null) {
            child = wrap!(child);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SizedBox(
              width: device.size.width,
              height: device.size.height,
              child: MediaQuery(
                data: MediaQueryData(
                  size: device.size,
                  devicePixelRatio: device.devicePixelRatio,
                  textScaler: TextScaler.linear(device.textScale),
                  platformBrightness: device.brightness,
                  padding: device.safeArea,
                ),
                child: child,
              ),
            ),
          );
        }),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: scenarioColumn,
    );
  }
}

Size _calculateSurface(List<TestDevice> devices, Axis direction) {
  if (direction == Axis.horizontal) {
    final width = devices.fold<double>(0, (sum, d) => sum + d.size.width);

    final maxHeight = devices
        .map((d) => d.size.height)
        .reduce((a, b) => a > b ? a : b);

    return Size(width + (devices.length * 24), maxHeight + 120);
  } else {
    final height = devices.fold<double>(0, (sum, d) => sum + d.size.height);

    final maxWidth = devices
        .map((d) => d.size.width)
        .reduce((a, b) => a > b ? a : b);

    return Size(maxWidth + 120, height + (devices.length * 24));
  }
}
