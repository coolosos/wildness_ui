part of '../elementary.dart';

@immutable
class ElementaryApp extends SingleChildStatelessWidget {
  const ElementaryApp({
    required ElementaryProperties elementaryProperties,
    TextStyle? defaultTextStyle,
    super.key,
    super.child,
  })  : _elementaryProperties = elementaryProperties,
        _defaultTextStyle = defaultTextStyle;

  factory ElementaryApp.withDefaultTheme({
    required ElementaryProperties elementaryProperties,
    TextStyle? defaultTextStyle,
    Color? primaryColor,
    Key? key,
    Widget? child,
  }) {
    return ElementaryApp(
      elementaryProperties: elementaryProperties,
      defaultTextStyle: defaultTextStyle,
      key: key,
      child: CustomDefaultTheme(
        primaryColor: primaryColor,
        defaultTextStyle: defaultTextStyle,
        child: child,
      ),
    );
  }

  final ElementaryProperties _elementaryProperties;
  final TextStyle? _defaultTextStyle;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    MediaQueryData mediaQuery =
        MediaQuery.maybeOf(context) ?? const MediaQueryData();

    TextStyle defaultTextStyle = _defaultTestStyle();

    final Brightness platformBrightness =
        _elementaryProperties.forzeThemeMode ?? mediaQuery.platformBrightness;
    // MediaQuery.platformBrightnessOf(context);

    return ElementaryProvider(
      data: Elementary(
        components: _elementaryProperties.components(
          brightness: platformBrightness,
        ),
        fundations: _elementaryProperties.fundations(
          brightness: platformBrightness,
        ),
        physics: _elementaryProperties.physics,
      ),
      child: MediaQuery(
        data: mediaQuery.copyWith(
          textScaler: mediaQuery.textScaler.clamp(
            minScaleFactor: _elementaryProperties.minScaleFactor,
            maxScaleFactor: _elementaryProperties.maxScaleFactor,
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
      DiagnosticsProperty<ElementaryProperties>(
        'elementaryProperties',
        _elementaryProperties,
        showName: false,
      ),
    );
  }
}
