/// Default Material theme configuration applied when integrating with Wildness.
library;

import 'package:flutter/material.dart'
    show
        BottomSheetThemeData,
        Colors,
        DialogThemeData,
        ScrollbarThemeData,
        Theme,
        ThemeData,
        VisualDensity,
        WidgetStateProperty;

import '../library.dart';

/// A wrapper widget that applies customized Material [ThemeData] styles
/// harmonized with Wildness configuration properties like primary color and default text style.
final class CustomDefaultTheme extends SingleChildStatelessWidget {
  /// Creates a [CustomDefaultTheme].
  const new({
    required this._primaryColor,
    required this._defaultTextStyle,
    super.key,
    super.child,
  });

  final Color? _primaryColor;
  final TextStyle? _defaultTextStyle;

  ThemeData _defaultMaterialTheme({
    required ThemeData defaultTheme,
    required Brightness brightness,
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
      brightness: brightness,
      primaryColor: _primaryColor,
      visualDensity: VisualDensity.standard,
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(true),
        trackColor: WidgetStateProperty.all(_primaryColor),
        thumbColor: WidgetStateProperty.all(_primaryColor),
      ),
      dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
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
    final brightness = MediaQuery.platformBrightnessOf(context);
    return Theme(
      data: _defaultMaterialTheme(
        defaultTheme: defaultTheme,
        brightness: brightness,
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
