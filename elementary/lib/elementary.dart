library elementary;

import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import '../library.dart';

part 'properties.dart';
part 'base/elementary_base.dart';
// part 'schemas/colors.dart';
// part 'schemas/typographies.dart';
// part 'schemas/fonts.dart';
// part 'schemas/assets.dart';
part 'base/configuration.dart';

part 'elementary_provider.dart';
part 'elementary_components.dart';

@immutable
class ElementaryApp extends SingleChildStatelessWidget {
  const ElementaryApp({
    required ElementaryProperties elementaryProperties,
    TextStyle? defaultTextStyle,
    super.key,
    super.child,
  })  : _elementaryProperties = elementaryProperties,
        _defaultTextStyle = defaultTextStyle;

  factory ElementaryApp.withUnMaterialTheme({
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
      child: CustomUnMaterialTheme(
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

    final elementaryTheme = ElementaryComponents.themeStyleOf(
      context: context,
      config: _elementaryProperties,
    );

    TextStyle defaultTextStyle = _defaultTestStyle();

    return ElementaryProvider(
      data: elementaryTheme,
      child: MediaQuery(
        data: mediaQuery.copyWith(
          textScaler: mediaQuery.textScaler.clamp(
            minScaleFactor: _elementaryProperties.minScaleFactor,
            maxScaleFactor: _elementaryProperties.maxScaleFactor,
          ),
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

class CustomUnMaterialTheme extends SingleChildStatelessWidget {
  const CustomUnMaterialTheme({
    required Color? primaryColor,
    required TextStyle? defaultTextStyle,
    super.key,
    super.child,
  })  : _primaryColor = primaryColor,
        _defaultTextStyle = defaultTextStyle;

  final Color? _primaryColor;
  final TextStyle? _defaultTextStyle;

  ThemeData _defaultMaterialTheme({
    required ThemeData defaultTheme,
  }) {
    final textTheme = defaultTheme.textTheme.apply(
      displayColor: _defaultTextStyle?.color,
      bodyColor: _defaultTextStyle?.color,
      decoration: _defaultTextStyle?.decoration,
      decorationColor: _defaultTextStyle?.decorationColor,
      decorationStyle: _defaultTextStyle?.decorationStyle,
      fontFamily: _defaultTextStyle?.fontFamily,
    );

    final materialTheme = defaultTheme.copyWith(
      primaryColor: _primaryColor,
      visualDensity: VisualDensity.standard,
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.all(true),
        trackColor: MaterialStateProperty.all(
          _primaryColor,
        ),
        thumbColor: MaterialStateProperty.all(
          _primaryColor,
        ),
      ),
      dialogTheme: const DialogTheme(
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      inputDecorationTheme: defaultTheme.inputDecorationTheme.copyWith(
        labelStyle: _defaultTextStyle,
        helperStyle: _defaultTextStyle,
        hintStyle: _defaultTextStyle,
        errorStyle: _defaultTextStyle,
        prefixStyle: _defaultTextStyle,
        counterStyle: _defaultTextStyle,
      ),
      sliderTheme: defaultTheme.sliderTheme.copyWith(
        valueIndicatorTextStyle: _defaultTextStyle,
      ),
      chipTheme: defaultTheme.chipTheme.copyWith(
        labelStyle: _defaultTextStyle,
        secondaryLabelStyle: _defaultTextStyle,
      ),
    );
    return materialTheme;
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final defaultTheme = Theme.of(context);
    return Theme(
      data: _defaultMaterialTheme(
        defaultTheme: defaultTheme,
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
