part of "../toolkit.dart";

const bgColor = Color.fromARGB(255, 234, 255, 217);

/// This [elementaryAppWrapper] is a convenience function to wrap your widget in [ElementaryApp]
/// Wraps your widget in MaterialApp, inject  custom theme, localizations, override  surfaceSize and platform
///
/// [localizationsDelegates] is list of [LocalizationsDelegate] that is required for this test
///
/// [supportedLocales] will set supported supportedLocales, defaults to [Locale('en')]
WidgetWrapper elementaryWidgetWrapper({
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  ElementaryProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor = const Color.fromARGB(255, 3, 85, 3),
}) {
  return (child) => elementaryApp(
        child: child,
        config: config,
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        defaultTextStyle: defaultTextStyle,
        primaryColor: primaryColor,
      );
}

ElementaryApp elementaryApp({
  required Widget child,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  ElementaryProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
}) {
  return ElementaryApp.withDefaultTheme(
    defaultTextStyle: defaultTextStyle,
    primaryColor: primaryColor,
    elementaryProperties: config ??
        const ElementaryProperties(
          forzeThemeMode: Brightness.dark,
        ),
    child: ElementaryBuilder(
      builder: (context, themeData) => WidgetsApp(
        debugShowCheckedModeBanner: false,
        title: 'Test App',
        initialRoute: 'root',
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) {
            return ColoredBox(
              color: bgColor,
              child: child,
            );
          },
          settings: settings,
        ),
        localizationsDelegates: localizationsDelegates ??
            const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
        color: Theme.of(context).colorScheme.primary,
        supportedLocales: supportedLocales ?? const [Locale('es')],
      ),
    ),
  );
}
