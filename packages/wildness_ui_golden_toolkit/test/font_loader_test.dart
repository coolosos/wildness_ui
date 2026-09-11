import 'package:flutter_test/flutter_test.dart';
import 'package:wildness_ui_golden_toolkit/src/font_loader.dart';

void main() {
  group('derivedFontFamily', () {
    test('returns overridable font family directly', () {
      expect(derivedFontFamily({'family': 'Roboto'}), 'Roboto');
      expect(derivedFontFamily({'family': '.SF UI Text'}), '.SF UI Text');
      expect(derivedFontFamily({'family': '.SF Pro Display'}), '.SF Pro Display');
    });

    test('extracts overridable font name from packages prefix', () {
      expect(
        derivedFontFamily({'family': 'packages/my_design_system/Roboto'}),
        'Roboto',
      );
    });

    test('derives package-scoped font family from fonts asset path', () {
      final fontDef = {
        'family': 'CustomBrandFont',
        'fonts': [
          {'asset': 'packages/brand_icons/fonts/CustomBrandFont.ttf'},
        ],
      };

      expect(
        derivedFontFamily(fontDef),
        'packages/brand_icons/CustomBrandFont',
      );
    });

    test('returns standard family when not overridable and no package asset prefix', () {
      final fontDef = {
        'family': 'LocalAppFont',
        'fonts': [
          {'asset': 'assets/fonts/LocalAppFont.ttf'},
        ],
      };

      expect(derivedFontFamily(fontDef), 'LocalAppFont');
    });

    test('returns empty string when family is missing or empty', () {
      expect(derivedFontFamily({}), '');
      expect(derivedFontFamily({'family': ''}), '');
    });
  });
}
