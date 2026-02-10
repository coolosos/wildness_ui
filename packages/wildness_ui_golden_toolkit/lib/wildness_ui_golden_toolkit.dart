import 'dart:io' show Platform;

import 'package:flutter/material.dart' show Theme;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:wildness_ui/wildness.dart';
import 'package:wildness_ui_golden_toolkit/src/font_loader.dart';

export 'package:flutter_test/flutter_test.dart';

part 'src/component.dart';
part 'src/list_devices.dart';
part 'src/test_component.dart';
part 'src/tester_extended.dart';
part 'src/wildness_wrapper.dart';

/// create a [flutter_test_config.dart]
/// and set [testExecutable] function for add default config
/// ```dart
/// Future<void> testExecutable(Future<void> Function() testMain) async {
///   return runWithConfiguration(testMain);
/// }
/// ```
Future<void> runWithConfiguration(Future<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await loadAppFonts();

  if (!Platform.isMacOS) {
    goldenFileComparator = _NoopGoldenComparator();
  }

  await testMain();
}

class _NoopGoldenComparator extends GoldenFileComparator {
  @override
  Uri get basedir => Uri.parse('');

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async => true;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {}
}
