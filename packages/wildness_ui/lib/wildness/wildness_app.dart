part of '../wildness.dart';

@immutable
class WildnessApp extends SingleChildStatelessWidget {
  const WildnessApp({
    required WildnessProperties wildnessProperties,
    TextStyle? defaultTextStyle,
    super.key,
    super.child,
  }) : _wildnessProperties = wildnessProperties,
       _defaultTextStyle = defaultTextStyle;

  factory WildnessApp.withDefaultTheme({
    required WildnessProperties wildnessProperties,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
    Key? key,
    Widget? child,
  }) {
    return WildnessApp(
      wildnessProperties: wildnessProperties,
      defaultTextStyle: defaultTextStyle,
      key: key,
      child: CustomDefaultTheme(
        primaryColor: primaryColor,
        defaultTextStyle: defaultTextStyle,
        child: child,
      ),
    );
  }

  final WildnessProperties _wildnessProperties;
  final TextStyle? _defaultTextStyle;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final mediaQuery = MediaQuery.maybeOf(context) ?? const MediaQueryData();

    final defaultTextStyle = _defaultTextStyle ?? _defaultTestStyle();

    final platformBrightness =
        _wildnessProperties.forceThemeMode ?? mediaQuery.platformBrightness;

    final wildness = Wildness(
      components: _wildnessProperties.components(
        brightness: platformBrightness,
      ),
      resources: _wildnessProperties.resources(brightness: platformBrightness),
      physics: _wildnessProperties.physics,
    );

    Widget current = MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: mediaQuery.textScaler.clamp(
          minScaleFactor: _wildnessProperties.minScaleFactor,
          maxScaleFactor: _wildnessProperties.maxScaleFactor,
        ),
        platformBrightness: platformBrightness,
      ),
      child: DefaultTextStyle(
        style: defaultTextStyle,
        child: child ?? const SizedBox.shrink(),
      ),
    );

    for (final entry in wildness.components.entries) {
      current = WildnessComponentProvider(
        key: ValueKey(entry.key),
        data: entry.value,
        child: current,
      );
    }
    for (final entry in wildness.resources.entries) {
      current = WildnessComponentProvider(
        key: ValueKey(entry.key),
        data: entry.value,
        child: current,
      );
    }

    return WildnessProvider(data: wildness, child: current);
  }

  TextStyle _defaultTestStyle() {
    const defaultTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: -0.26,
      color: Color(0xFF000000),
      textBaseline: TextBaseline.alphabetic,
    );
    if (kDebugMode &&
        (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST'))) {
      return defaultTextStyle.copyWith(
        color: const Color(0xffFF2323),
        decorationColor: const Color(0xffFFCE51),
        decoration: TextDecoration.lineThrough,
      );
    }
    return defaultTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<WildnessProperties>(
        'wildnessProperties',
        _wildnessProperties,
        showName: false,
      ),
    );
  }
}
