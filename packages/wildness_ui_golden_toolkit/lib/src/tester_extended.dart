part of '../wildness_ui_golden_toolkit.dart';

const Size _defaultSize = Size(800, 600);

class GoldenRenderConfig {
  const GoldenRenderConfig({
    this.size = _defaultSize,
    this.devicePixelRatio = 1.0,
    this.additionalPump = const Duration(milliseconds: 16),
  });

  factory GoldenRenderConfig.device(TestDevice device) {
    return GoldenRenderConfig(
      size: device.size,
      devicePixelRatio: device.devicePixelRatio,
      additionalPump: const Duration(milliseconds: 120),
    );
  }

  final Size size;
  final double devicePixelRatio;
  final Duration additionalPump;
}

Future<void> _pumpAndMatchInternal({
  required WidgetTester tester,
  required Widget widget,
  required String groupTitle,
  required GoldenRenderConfig renderConfig,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
  Key? touchKey,
  Key? hoverKey,
  Future<TestGesture?> Function(WidgetTester tester)? gestureBuilder,
}) async {
  _setSurfaceSize(
    tester,
    renderConfig.size,
    devicePixelRatio: renderConfig.devicePixelRatio,
  );

  await tester.pumpWidget(
    wildnessWidgetWrapper(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      config: config,
      defaultTextStyle: defaultTextStyle,
      primaryColor: primaryColor,
    )(widget),
  );

  await tester.pump();
  await tester.pumpAndSettle();

  await _manageKeys(touchKey, hoverKey, tester);
  await gestureBuilder?.call(tester);

  await tester.pump();
  await tester.pump(renderConfig.additionalPump);
  await tester.pumpAndSettle();
  await tester.pump();

  expect(
    find.byWidget(widget),
    matchesGoldenFile(tester._screenName(groupTitle)),
  );
}

extension GoldenTesterExt on WidgetTester {
  String _screenName(String groupTitle) {
    final testName = testDescription.toLowerCase().replaceAll(' ', '_');
    final group = groupTitle.toLowerCase().replaceAll(' ', '_');
    return 'goldens/$group/$testName.png';
  }

  Future<void> pumpWidgetAndMatch({
    required Widget widget,
    required String groupTitle,
    Size surfaceSize = _defaultSize,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    WildnessProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
    Key? touchKey,
    Key? hoverKey,
    Future<TestGesture?> Function(WidgetTester tester)? gestureBuilder,
  }) {
    return _pumpAndMatchInternal(
      tester: this,
      widget: widget,
      groupTitle: groupTitle,
      renderConfig: GoldenRenderConfig(size: surfaceSize),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      config: config,
      defaultTextStyle: defaultTextStyle,
      primaryColor: primaryColor,
      touchKey: touchKey,
      hoverKey: hoverKey,
      gestureBuilder: gestureBuilder,
    );
  }

  Future<void> pumpDeviceAndMatch({
    required TestDevice device,
    required Widget widget,
    required String groupTitle,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    WildnessProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
    Key? touchKey,
    Key? hoverKey,
    Future<TestGesture?> Function(WidgetTester tester)? gestureBuilder,
  }) {
    return _pumpAndMatchInternal(
      tester: this,
      widget: widget,
      groupTitle: groupTitle,
      renderConfig: GoldenRenderConfig.device(device),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      config: config,
      defaultTextStyle: defaultTextStyle,
      primaryColor: primaryColor,
      touchKey: touchKey,
      hoverKey: hoverKey,
      gestureBuilder: gestureBuilder,
    );
  }
}

void _setSurfaceSize(
  WidgetTester tester,
  Size size, {
  double devicePixelRatio = 1.0,
}) {
  tester.view.physicalSize = size * devicePixelRatio;
  tester.view.devicePixelRatio = devicePixelRatio;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _manageKeys(
  Key? touchKey,
  Key? hoverKey,
  WidgetTester tester,
) async {
  if (touchKey != null) {
    await tester.startGesture(
      tester.getCenter(find.byKey(touchKey)),
      kind: PointerDeviceKind.touch,
    );
    await tester.pump(const Duration(milliseconds: 150));
  }

  if (hoverKey != null) {
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    final centerHover = tester.getRect(find.byKey(hoverKey)).center;
    await mouse.moveTo(centerHover);
  }
}
