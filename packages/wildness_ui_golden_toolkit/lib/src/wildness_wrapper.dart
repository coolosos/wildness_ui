part of '../wildness_ui_golden_toolkit.dart';

const double textScaleFactorMaxSupported = 3.2;

Widget Function(Widget child) wildnessWidgetWrapper({
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
  WildnessProperties? config,
  TextStyle? defaultTextStyle,
  Color? primaryColor = const Color.fromARGB(255, 3, 85, 3),
}) {
  return (child) => ColoredBox(
    color: const Color.fromARGB(255, 255, 255, 255),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(
          size: Size(800, 600),
          devicePixelRatio: 1,
          textScaler: TextScaler.linear(1),
        ),
        child: DefaultTextStyle(
          style:
              defaultTextStyle?.copyWith(fontFamily: 'Roboto') ??
              const TextStyle(),
          child: child,
        ),
      ),
    ),
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
    wildnessProperties:
        config ?? const WildnessProperties(forceThemeMode: Brightness.dark),
    child: WildnessBuilder(
      builder: (context, themeData) => WidgetsApp(
        debugShowCheckedModeBanner: false,
        title: 'Test App',
        color: Theme.of(context).colorScheme.primary,
        home: child,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales ?? const [Locale('es')],
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (_, _, _) => builder(context),
            ),
      ),
    ),
  );
}
