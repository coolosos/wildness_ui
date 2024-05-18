library toolkit;

import 'package:elementary_ui/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:meta/meta.dart';

part 'src/component.dart';
part 'src/wrapper.dart';
part 'src/list_devices.dart';
part 'src/test_component.dart';
part 'src/tester_extended.dart';

/// create a [flutter_test_config.dart]
/// and set [testExecutable] funciont for add default config
/// ```
/// Future<void> testExecutable(Future<void> Function() testMain) async {
///   return runWithConfiguration(testMain);
/// }
/// ```
Future<void> runWithConfiguration(Future<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      skipGoldenAssertion: () => !Platform.isMacOS,
      defaultDevices: const [Device.phone, Device.iphone11],
    ),
  );
}
