part of '../wildness_ui_golden_toolkit.dart';

const Size _defaultSize = Size(800, 600);

///CustomPump is a function that lets you do custom pumping before golden evaluation.
///Sometimes, you want to do a golden test for different stages of animations, so its crucial to have a precise control over pumps and durations
typedef CustomPump = Future<void> Function(WidgetTester);

/// Typedef for wrapping a widget with one or more other widgets
typedef WidgetWrapper = Widget Function(Widget);

/// Hook for running arbitrary behavior for a particular scenario
typedef OnScenarioCreate = Future<void> Function(Key scenarioWidgetKey);

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
    bool autoHeight = true,
    double textScaleSize = 1.0,
    Future<void> Function()? gestureBuilder,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    WildnessProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
  }) async {
    _setSurfaceSize(this, surfaceSize);
    await pumpWidget(
      wildnessWidgetWrapper(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        config: config,
        defaultTextStyle: defaultTextStyle,
        primaryColor: primaryColor,
      )(widget),
    );

    await pumpAndSettle();

    if (gestureBuilder != null) {
      await gestureBuilder();
      await pumpAndSettle();
    }

    expect(
      find.byKey(const Key('__golden_root__')),
      matchesGoldenFile(_screenName(groupTitle)),
    );
  }

  Future<void> pumpDeviceAndMatch({
    required TestDevice device,
    required Widget widget,
    required String groupTitle,
    bool autoHeight = true,
    Future<void> Function()? gestureBuilder,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    WildnessProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
  }) async {
    _setSurfaceSize(
      this,
      device.size,
      devicePixelRatio: device.devicePixelRatio,
    );

    await pumpWidget(
      wildnessWidgetWrapper(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        config: config,
        defaultTextStyle: defaultTextStyle,
        primaryColor: primaryColor,
      )(widget),
    );

    await pumpAndSettle();

    if (gestureBuilder != null) {
      await gestureBuilder();
      await pumpAndSettle();
    }

    expect(find.byWidget(widget), matchesGoldenFile(_screenName(groupTitle)));
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
