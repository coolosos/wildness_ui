import 'package:flutter/material.dart';
import 'package:wildness_ui/wildness.dart';

// ---------------------------------------------------------------------------
// 1. Define a Custom Component Theme Data
// ---------------------------------------------------------------------------

base class CardThemeData extends WildnessBase<CardThemeData> {
  const new({
    required this.backgroundColor,
    required this.borderRadius,
    required this.elevation,
    required this.textColor,
  });

  final Color backgroundColor;
  final double borderRadius;
  final double elevation;
  final Color textColor;

  @override
  CardThemeData copyWith({
    Color? backgroundColor,
    double? borderRadius,
    double? elevation,
    Color? textColor,
  }) {
    return CardThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  CardThemeData lerp(WildnessBase<CardThemeData>? other, double t) {
    if (other is! CardThemeData) return this;
    return CardThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      elevation: elevation + (other.elevation - elevation) * t,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        borderRadius,
        elevation,
        textColor,
      ];
}

// ---------------------------------------------------------------------------
// 2. Define a Custom Component Theme InheritedTheme
// ---------------------------------------------------------------------------

final class CardComponentTheme extends ComponentTheme<CardThemeData> {
  const new({required super.data, required super.child, super.key});

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CardComponentTheme(data: data, child: child);
  }
}

// ---------------------------------------------------------------------------
// 3. Custom Themed UI Component
// ---------------------------------------------------------------------------

class WildCard extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme =
        ComponentTheme.kindThemeData<CardThemeData>(context) ??
        const CardThemeData(
          backgroundColor: Colors.white,
          borderRadius: 8,
          elevation: 2,
          textColor: Colors.black87,
        );

    return Material(
      color: theme.backgroundColor,
      elevation: theme.elevation,
      borderRadius: BorderRadius.circular(theme.borderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: theme.textColor.withAlpha(200),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Main Application with Theme Configurations
// ---------------------------------------------------------------------------

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const new({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  Brightness _brightness = Brightness.light;

  void _toggleTheme() {
    setState(() {
      _brightness = _brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    const lightCardTheme = CardThemeData(
      backgroundColor: Color(0xFFF3F4F6),
      borderRadius: 16,
      elevation: 3,
      textColor: Color(0xFF111827),
    );

    const darkCardTheme = CardThemeData(
      backgroundColor: Color(0xFF1F2937),
      borderRadius: 16,
      elevation: 6,
      textColor: Color(0xFFF9FAFB),
    );

    const accentCardTheme = CardThemeData(
      backgroundColor: Color(0xFF6366F1),
      borderRadius: 24,
      elevation: 8,
      textColor: Colors.white,
    );

    const wrappedCardTheme = CardThemeData(
      backgroundColor: Color(0xFF10B981),
      borderRadius: 20,
      elevation: 5,
      textColor: Colors.white,
    );

    final wildnessProperties = WildnessProperties(
      forceThemeMode: _brightness,
      components: const Configuration(
        light: [lightCardTheme],
        dark: [darkCardTheme],
      ),
    );

    return WildnessApp.withDefaultTheme(
      wildnessProperties: wildnessProperties,
      child: MaterialApp(
        title: 'Wildness UI Example',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: _brightness),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Wildness UI Design System'),
            actions: [
              IconButton(
                icon: Icon(
                  _brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: _toggleTheme,
                tooltip: 'Toggle Theme',
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Global Theme Consumer:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    WildCard(
                      title: 'Standard Wildness Card',
                      subtitle:
                          'Resolves styles from the root WildnessApp configuration.',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Local Override (WildnessComponentProvider):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    WildnessComponentProvider<CardThemeData>(
                      data: accentCardTheme,
                      child: WildCard(
                        title: 'Overridden Accent Card',
                        subtitle:
                            'This card receives custom styling without affecting siblings.',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Wrapped Theme (CardComponentTheme):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    CardComponentTheme(
                      data: wrappedCardTheme,
                      child: WildCard(
                        title: 'Inherited Wrapped Card',
                        subtitle:
                            'Demonstrates custom ComponentTheme wrapper integration.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
