import 'package:flutter/material.dart';
import 'package:wildness_ui_golden_toolkit/wildness_ui_golden_toolkit.dart';

void main() {
  group('group_name', () {
    testColumnComponent(
      groupName: 'test_component_column_group',
      name: 'test_component_column',
      surfaceSize: const Size(800, 300),
      scenarios: [
        Component(
          name: 'test',
          widget: const LinearProgressIndicator(
            value: 0.5,
            color: Color.fromRGBO(0, 0, 0, 1),
            backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          ),
        ),
      ],
    );
    testDeviceComponent(
      groupName: 'test_device_component_group',
      name: 'test_device_component',
      devices: [
        const TestDevice(name: 'iPhone 12', size: Size(390, 844)),
        const TestDevice(name: 'iPad Pro', size: Size(1024, 1366)),
      ],
      scenarios: [
        Component(
          name: 'test',
          widget: const Column(
            children: [
              LinearProgressIndicator(
                value: 0.5,
                minHeight: 4,
                color: Color.fromRGBO(0, 0, 0, 1),
                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
              ),
            ],
          ),
        ),
      ],
    );
    testDevicesGolden(
      groupName: 'test_devices_group',
      name: 'test_devices_golden',
      devices: [
        const TestDevice(name: 'iPhone 12', size: Size(390, 844)),
        const TestDevice(name: 'iPad Pro', size: Size(1024, 1366)),
      ],
      scenarios: [
        Component(
          name: 'test',
          widget: const Column(
            children: [
              LinearProgressIndicator(
                value: 0.5,
                minHeight: 4,
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
