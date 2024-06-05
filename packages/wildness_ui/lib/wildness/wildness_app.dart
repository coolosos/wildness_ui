part of '../wildness.dart';

@immutable
class WildnessApp extends SingleChildStatelessWidget {
  const WildnessApp({
    required WildnessProperties wildnessProperties,
    TextStyle? defaultTextStyle,
    super.key,
    super.child,
  })  : _wildnessProperties = wildnessProperties,
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
    MediaQueryData mediaQuery =
        MediaQuery.maybeOf(context) ?? const MediaQueryData();

    TextStyle defaultTextStyle = _defaultTestStyle();

    final Brightness platformBrightness =
        _wildnessProperties.forceThemeMode ?? mediaQuery.platformBrightness;
    // MediaQuery.platformBrightnessOf(context);

    return WildnessProvider(
      data: Wildness(
        components: _wildnessProperties.components(
          brightness: platformBrightness,
        ),
        resources: _wildnessProperties.resources(
          brightness: platformBrightness,
        ),
        physics: _wildnessProperties.physics,
      ),
      child: MediaQuery(
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
      ),
    );
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
    return _defaultTextStyle ?? defaultTextStyle;
  }

  @override
  void debugFillProperties(
    DiagnosticPropertiesBuilder properties,
  ) {
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
