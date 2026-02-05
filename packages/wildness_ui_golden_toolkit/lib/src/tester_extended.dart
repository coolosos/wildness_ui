part of '../wildness_ui_golden_toolkit.dart';

extension GoldenTesterExt on WidgetTester {
  String _screenName(String groupTitle) {
    final testName = testDescription.toLowerCase().replaceAll(' ', '_');
    final group = groupTitle.toLowerCase().replaceAll(' ', '_');
    return '$group/$testName';
  }

  Future<void> pumpWidgetAndMatch({
    required Widget widget,
    required String groupTitle,
    Size surfaceSize = const Size(800, 600),
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
      MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScaleSize)),
        child: wildnessWidgetWrapper(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          config: config,
          defaultTextStyle: defaultTextStyle,
          primaryColor: primaryColor,
        )(widget),
      ),
    );

    await pumpAndSettle();

    if (gestureBuilder != null) {
      await gestureBuilder();
      await pumpAndSettle();
    }

    expect(find.byWidget(widget), matchesGoldenFile(_screenName(groupTitle)));
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
