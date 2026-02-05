part of '../wildness_ui_golden_toolkit.dart';

class Devices {
  Devices._();

  static const List<TestDevice> common = [
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
    required this.devicePixelRatio,
    required this.name,
  });
  final Size size;
  final double devicePixelRatio;
  final String name;
}
