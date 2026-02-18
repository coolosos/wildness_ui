# wildness_ui_golden_toolkit_example

Demonstrates how to use the wildness_ui_golden_toolkit_example plugin.

```dart
  group('group_name', () {
    testColumnComponent(
      groupName: "test_component_column_group",
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
  }
);
```