part of "../toolkit.dart";

extension DeviceExt on WidgetTester {
  String screenMatchesName(
    String groupTitle,
  ) {
    return '${groupTitle.toLowerCase().replaceAll(' ', '_')}/${testDescription.toLowerCase().replaceAll(' ', '_')}';
  }

  Future<void> pumpWidgetAndMatchWithGesture({
    required String groupTitle,
    required GoldenBuilder builder,
    required Future Function()? gestureBuilder,
    bool? autoHeight = true,
    Size? surfaceSize,
    double? textScaleSize,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    ElementaryProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
  }) async {
    await pumpWidgetBuilder(
      builder.build(),
      wrapper: elementaryWidgetWrapper(
        config: config,
        defaultTextStyle: defaultTextStyle,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        primaryColor: primaryColor,
      ),
      surfaceSize: surfaceSize ?? const Size(800, 600),
      textScaleSize: textScaleSize ?? 1.0,
    );

    await pumpAndSettle();

    await gestureBuilder?.call();

    await screenMatchesGolden(
      this,
      screenMatchesName(groupTitle),
      autoHeight: autoHeight,
    );
  }

  Future<void> pumpDeviceAndMatch({
    required String groupTitle,
    required DeviceBuilder builder,
    bool? autoHeight = true,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    ElementaryProperties? config,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
  }) async {
    await pumpDeviceBuilder(
      builder,
      wrapper: elementaryWidgetWrapper(
        config: config,
        defaultTextStyle: defaultTextStyle,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        primaryColor: primaryColor,
      ),
    );

    await screenMatchesGolden(
      this,
      screenMatchesName(groupTitle),
      autoHeight: autoHeight,
    );
  }
}
