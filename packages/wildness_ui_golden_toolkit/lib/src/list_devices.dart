part of "../wildness_ui_golden_toolkit.dart";

class Devices {
  Devices._();
  static const common = [
    Device(
      size: Size(320, 480),
      name: 'IPod touch',
      devicePixelRatio: 3 / 2,
    ),
    Device(
      size: Size(1440, 2880),
      name: 'Google Pixel 2 XL',
      devicePixelRatio: 18 / 9,
    ),
    Device(
      size: Size(320, 568),
      name: 'iPhone SE',
      devicePixelRatio: 2,
    ),
    Device(
      size: Size(480, 800),
      name: 'Nexus One',
      devicePixelRatio: 3 / 5,
    ),
    Device.iphone11,
    Device.tabletPortrait,
    Device.tabletLandscape,
  ];
}
