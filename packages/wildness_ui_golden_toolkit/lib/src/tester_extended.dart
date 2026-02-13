part of '../wildness_ui_golden_toolkit.dart';

const Size _defaultSize = Size(800, 600);

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
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    WildnessProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
    Future Function()? gestureBuilder,
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

    await gestureBuilder?.call();

    //await pump();
    //await pump(const Duration(milliseconds: 120));
    await pumpAndSettle();
    await pumpAndSettle();

    expect(find.byWidget(widget), matchesGoldenFile(_screenName(groupTitle)));
  }

  Future<void> pumpDeviceAndMatch({
    required TestDevice device,
    required Widget widget,
    required String groupTitle,
    bool autoHeight = true,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    WildnessProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
    Future Function()? gestureBuilder,
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

    await gestureBuilder?.call();

    await pump();
    await pump(const Duration(milliseconds: 120));
    await pumpAndSettle();

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
