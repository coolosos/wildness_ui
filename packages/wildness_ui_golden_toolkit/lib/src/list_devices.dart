part of '../wildness_ui_golden_toolkit.dart';

class Devices {
  Devices._();

  static const TestDevice phone = TestDevice(
    name: 'phone',
    size: Size(375, 667),
  );

  static const TestDevice iphone11 = TestDevice(
    name: 'iphone11',
    size: Size(414, 896),
    devicePixelRatio: 1,
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  );

  static const TestDevice iphoneSE = TestDevice(
    name: 'iphone_se',
    size: Size(320, 568),
    devicePixelRatio: 2,
  );

  static const TestDevice iPodTouch = TestDevice(
    name: 'iPod_touch',
    size: Size(320, 480),
    devicePixelRatio: 1.5,
  );

  static const TestDevice nexusOne = TestDevice(
    name: 'nexus_one',
    size: Size(480, 800),
    devicePixelRatio: 1.67,
  );

  static const TestDevice pixel2xl = TestDevice(
    name: 'pixel_2_xl',
    size: Size(1440, 2880),
    devicePixelRatio: 2,
  );

  static const TestDevice tabletPortrait = TestDevice(
    name: 'tablet_portrait',
    size: Size(768, 1024),
    devicePixelRatio: 2,
  );

  static const TestDevice tabletLandscape = TestDevice(
    name: 'tablet_landscape',
    size: Size(1024, 768),
    devicePixelRatio: 2,
  );
  static const List<TestDevice> all = [
    phone,
    iphone11,
    iphoneSE,
    iPodTouch,
    nexusOne,
    pixel2xl,
    tabletPortrait,
    tabletLandscape,
  ];

  static const List<TestDevice> phones = [
    phone,
    iphone11,
    iphoneSE,
    iPodTouch,
    nexusOne,
    pixel2xl,
  ];

  static const List<TestDevice> tablets = [tabletPortrait, tabletLandscape];

  static const List<TestDevice> ci = [iphone11, pixel2xl, tabletPortrait];

  static List<TestDevice> select(List<TestDevice> devices) => devices;

  static List<TestDevice> where(bool Function(TestDevice device) test) {
    return all.where(test).toList();
  }

  static List<TestDevice> named(List<String> names) {
    return all.where((d) => names.contains(d.name)).toList();
  }
}

class TestDevice {
  const TestDevice({
    required this.size,
    required this.name,
    this.devicePixelRatio = 1.0,
    this.textScale = 1.0,
    this.brightness = Brightness.light,
    this.safeArea = const EdgeInsets.all(0),
  });
  final String name;

  /// [size] specify device screen size. Ex: Size(1366, 1024))
  final Size size;

  /// [devicePixelRatio] specify device Pixel Ratio
  final double devicePixelRatio;

  /// [textScale] specify custom text scale
  final double textScale;

  /// [brightness] specify platform brightness
  final Brightness brightness;

  /// [safeArea] specify insets to define a safe area
  final EdgeInsets safeArea;

  /// [copyWith] convenience function for [Device] modification
  TestDevice copyWith({
    Size? size,
    double? devicePixelRatio,
    String? name,
    double? textScale,
    Brightness? brightness,
    EdgeInsets? safeArea,
  }) {
    return TestDevice(
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      name: name ?? this.name,
      textScale: textScale ?? this.textScale,
      brightness: brightness ?? this.brightness,
      safeArea: safeArea ?? this.safeArea,
    );
  }
}
