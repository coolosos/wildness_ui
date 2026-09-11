import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('Devices', () {
    test('standard device definitions have expected properties', () {
      expect(Devices.phone.name, 'phone');
      expect(Devices.phone.size, const Size(375, 667));

      expect(Devices.iphone11.name, 'iphone11');
      expect(Devices.iphone11.size, const Size(414, 896));
      expect(Devices.iphone11.safeArea, const EdgeInsets.only(top: 44, bottom: 34));

      expect(Devices.iphoneSE.name, 'iphone_se');
      expect(Devices.iphoneSE.size, const Size(320, 568));

      expect(Devices.iPodTouch.name, 'iPod_touch');
      expect(Devices.iPodTouch.size, const Size(320, 480));

      expect(Devices.nexusOne.name, 'nexus_one');
      expect(Devices.nexusOne.size, const Size(480, 800));

      expect(Devices.pixel2xl.name, 'pixel_2_xl');
      expect(Devices.pixel2xl.size, const Size(1440, 2880));

      expect(Devices.tabletPortrait.name, 'tablet_portrait');
      expect(Devices.tabletPortrait.size, const Size(768, 1024));

      expect(Devices.tabletLandscape.name, 'tablet_landscape');
      expect(Devices.tabletLandscape.size, const Size(1024, 768));
    });

    test('predefined device lists contain expected devices', () {
      expect(Devices.all.length, 8);
      expect(Devices.phones.length, 6);
      expect(Devices.tablets.length, 2);
      expect(Devices.ci.length, 3);

      expect(Devices.ci, containsAll([Devices.iphone11, Devices.pixel2xl, Devices.tabletPortrait]));
    });

    test('Devices.select returns the passed list unchanged', () {
      final selected = [Devices.iphoneSE, Devices.tabletLandscape];
      expect(Devices.select(selected), selected);
    });

    test('Devices.where filters devices according to predicate', () {
      final largeDevices = Devices.where((device) => device.size.width >= 768);

      expect(largeDevices, containsAll([Devices.pixel2xl, Devices.tabletPortrait, Devices.tabletLandscape]));
      expect(largeDevices, isNot(contains(Devices.phone)));
    });

    test('Devices.named returns devices matching given names', () {
      final namedDevices = Devices.named(['phone', 'iphone_se']);

      expect(namedDevices.length, 2);
      expect(namedDevices, containsAll([Devices.phone, Devices.iphoneSE]));
    });

    test('TestDevice.copyWith creates modified copy', () {
      const original = TestDevice(
        name: 'custom_device',
        size: Size(400, 800),
        devicePixelRatio: 2,
        safeArea: EdgeInsets.all(10),
      );

      final modified = original.copyWith(
        name: 'modified_device',
        size: const Size(500, 900),
        devicePixelRatio: 3,
        textScale: 1.5,
        brightness: Brightness.dark,
        safeArea: const EdgeInsets.all(20),
      );

      expect(modified.name, 'modified_device');
      expect(modified.size, const Size(500, 900));
      expect(modified.devicePixelRatio, 3);
      expect(modified.textScale, 1.5);
      expect(modified.brightness, Brightness.dark);
      expect(modified.safeArea, const EdgeInsets.all(20));

      final unchanged = original.copyWith();
      expect(unchanged.name, original.name);
      expect(unchanged.size, original.size);
    });
  });
}
