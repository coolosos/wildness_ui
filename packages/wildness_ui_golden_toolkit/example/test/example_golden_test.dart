import 'package:flutter/material.dart';
import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('group_name', () {
    testColumnComponent(
      name: 'test_component_column',
      surfaceSize: const Size(800, 300),
      scenarios: [
        Component(
          name: 'test',
          widget: LinearProgressIndicator(
            value: 0.5,
            color: Color.fromRGBO(0, 0, 0, 1),
            backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          ),
        ),
      ],
    );
    testDeviceComponent(
      name: 'test_device_component',
      surfaceSize: const Size(800, 300),

      devices: [
        Device(name: 'iPhone 12', size: const Size(390, 844)),
        Device(name: 'iPad Pro', size: const Size(1024, 1366)),
      ],
      scenarios: [
        Component(
          name: 'test',
          widget: Column(
            children: [
              LinearProgressIndicator(
                value: 0.5,
                minHeight: 4.0,
                color: Color.fromRGBO(0, 0, 0, 1),
                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  });
}
