part of "../toolkit.dart";

const bgColor = Color.fromARGB(255, 234, 255, 217);

/// This [wildnessAppWrapper] is a convenience function to wrap your widget in [wildnessApp]
/// Wraps your widget in MaterialApp, inject  custom theme, localizations, override  surfaceSize and platform
///
/// [localizationsDelegates] is list of [LocalizationsDelegate] that is required for this test
///
/// [supportedLocales] will set supported supportedLocales, defaults to [Locale('en')]
WidgetWrapper wildnessWidgetWrapper({
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor = const Color.fromARGB(255, 3, 85, 3),
}) {
  return (child) => wildnessApp(
        child: child,
        config: config,
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        defaultTextStyle: defaultTextStyle,
        primaryColor: primaryColor,
      );
}

WildnessApp wildnessApp({
  required Widget child,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor,
}) {
  return WildnessApp.withDefaultTheme(
    defaultTextStyle: defaultTextStyle,
    primaryColor: primaryColor,
    wildnessProperties: config ??
        const WildnessProperties(
          forzeThemeMode: Brightness.dark,
        ),
    child: WildnessBuilder(
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
