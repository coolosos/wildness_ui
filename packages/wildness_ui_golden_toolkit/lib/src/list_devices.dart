part of '../wildness_ui_golden_toolkit.dart';

class Devices {
  Devices._();

  static const List<TestDevice> common = [
    TestDevice(name: 'phone', size: Size(375, 667)),
    TestDevice(
      name: 'iphone11',
      size: Size(414, 896),
      devicePixelRatio: 1,
      safeArea: EdgeInsets.only(top: 44, bottom: 34),
    ),
    TestDevice(size: Size(320, 480), name: 'iPod touch', devicePixelRatio: 1.5),
    TestDevice(
      size: Size(1440, 2880),
      name: 'Google Pixel 2 XL',
      devicePixelRatio: 2,
    ),
    TestDevice(size: Size(320, 568), name: 'iPhone SE', devicePixelRatio: 2),
    TestDevice(size: Size(480, 800), name: 'Nexus One', devicePixelRatio: 1.67),
    TestDevice(size: Size(414, 896), name: 'iPhone 11', devicePixelRatio: 2),
    TestDevice(
      size: Size(768, 1024),
      name: 'Tablet Portrait',
      devicePixelRatio: 2,
    ),
    TestDevice(
      size: Size(1024, 768),
      name: 'Tablet Landscape',
      devicePixelRatio: 2,
    ),
  ];
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
