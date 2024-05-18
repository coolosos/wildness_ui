part of "../toolkit.dart";

class Component {
  Component({
    required this.name,
    required this.widget,
    this.textScaleFactor,
  });

  final String name;
  final Widget widget;

  final double? textScaleFactor;
}
