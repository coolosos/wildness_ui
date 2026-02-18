import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

Future<void> testExecutable(Future<void> Function() testMain) =>
    runWithConfiguration(testMain);
