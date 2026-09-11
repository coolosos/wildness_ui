import 'package:wildness_ui/wildness.dart';

// ---------------------------------------------------------------------------
// 1. Custom Button Component Theme
// ---------------------------------------------------------------------------

base class ButtonThemeData extends WildnessBase<ButtonThemeData> {
  const new({
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.padding,
  });

  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  ButtonThemeData copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return ButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  ButtonThemeData lerp(WildnessBase<ButtonThemeData>? other, double t) {
    if (other is! ButtonThemeData) return this;
    return ButtonThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        textColor,
        borderRadius,
        padding,
      ];
}

final class ButtonComponentTheme extends ComponentTheme<ButtonThemeData> {
  const new({required super.data, required super.child, super.key});

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ButtonComponentTheme(data: data, child: child);
  }
}

// ---------------------------------------------------------------------------
// 2. Custom Card Component Theme
// ---------------------------------------------------------------------------

base class CardThemeData extends WildnessBase<CardThemeData> {
  const new({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.titleColor,
    required this.bodyColor,
  });

  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final Color titleColor;
  final Color bodyColor;

  @override
  CardThemeData copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? borderRadius,
    Color? titleColor,
    Color? bodyColor,
  }) {
    return CardThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      titleColor: titleColor ?? this.titleColor,
      bodyColor: bodyColor ?? this.bodyColor,
    );
  }

  @override
  CardThemeData lerp(WildnessBase<CardThemeData>? other, double t) {
    if (other is! CardThemeData) return this;
    return CardThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      borderColor:
          Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      titleColor: Color.lerp(titleColor, other.titleColor, t) ?? titleColor,
      bodyColor: Color.lerp(bodyColor, other.bodyColor, t) ?? bodyColor,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        borderColor,
        borderRadius,
        titleColor,
        bodyColor,
      ];
}

final class CardComponentTheme extends ComponentTheme<CardThemeData> {
  const new({required super.data, required super.child, super.key});

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CardComponentTheme(data: data, child: child);
  }
}

// ---------------------------------------------------------------------------
// 3. Pure Standalone Widgets (Zero Material Dependencies)
// ---------------------------------------------------------------------------

class WildButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme =
        ComponentTheme.kindThemeData<ButtonThemeData>(context) ??
        const ButtonThemeData(
          backgroundColor: Color(0xFF3B82F6),
          textColor: Color(0xFFFFFFFF),
          borderRadius: 8,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: theme.padding,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(theme.borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

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
          backgroundColor: Color(0xFFFFFFFF),
          borderColor: Color(0xFFE5E7EB),
          borderRadius: 12,
          titleColor: Color(0xFF111827),
          bodyColor: Color(0xFF6B7280),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: theme.bodyColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Pure WidgetsApp Application
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
    const lightButtonTheme = ButtonThemeData(
      backgroundColor: Color(0xFF2563EB),
      textColor: Color(0xFFFFFFFF),
      borderRadius: 10,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    const darkButtonTheme = ButtonThemeData(
      backgroundColor: Color(0xFF3B82F6),
      textColor: Color(0xFFFFFFFF),
      borderRadius: 10,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    const lightCardTheme = CardThemeData(
      backgroundColor: Color(0xFFF9FAFB),
      borderColor: Color(0xFFE5E7EB),
      borderRadius: 12,
      titleColor: Color(0xFF111827),
      bodyColor: Color(0xFF4B5563),
    );

    const darkCardTheme = CardThemeData(
      backgroundColor: Color(0xFF1F2937),
      borderColor: Color(0xFF374151),
      borderRadius: 12,
      titleColor: Color(0xFFF9FAFB),
      bodyColor: Color(0xFF9CA3AF),
    );

    const accentCardTheme = CardThemeData(
      backgroundColor: Color(0xFF312E81),
      borderColor: Color(0xFF6366F1),
      borderRadius: 16,
      titleColor: Color(0xFFEEF2FF),
      bodyColor: Color(0xFFC7D2FE),
    );

    const successCardTheme = CardThemeData(
      backgroundColor: Color(0xFF064E3B),
      borderColor: Color(0xFF10B981),
      borderRadius: 16,
      titleColor: Color(0xFFECFDF5),
      bodyColor: Color(0xFFA7F3D0),
    );

    const customButtonTheme = ButtonThemeData(
      backgroundColor: Color(0xFF059669),
      textColor: Color(0xFFFFFFFF),
      borderRadius: 20,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );

    final wildnessProperties = WildnessProperties(
      forceThemeMode: _brightness,
      components: const Configuration(
        light: [lightButtonTheme, lightCardTheme],
        dark: [darkButtonTheme, darkCardTheme],
      ),
    );

    final isDark = _brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF111827) : const Color(0xFFFFFFFF);
    final headerTextColor = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);

    return WildnessApp(
      wildnessProperties: wildnessProperties,
      child: WidgetsApp(
        title: 'Wildness UI Pure Design System Example',
        color: const Color(0xFF2563EB),
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            color: surfaceColor,
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Wildness UI',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: headerTextColor,
                          ),
                        ),
                        ButtonComponentTheme(
                          data: customButtonTheme,
                          child: WildButton(
                            label: isDark ? 'Light Mode' : 'Dark Mode',
                            onTap: _toggleTheme,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Global Theme Consumer:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: headerTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const WildCard(
                      title: 'Standard Component',
                      subtitle:
                          'Inherits colors, borders, and styles automatically from root WildnessApp.',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Subtree Override (WildnessComponentProvider):',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: headerTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const WildnessComponentProvider<CardThemeData>(
                      data: accentCardTheme,
                      child: WildCard(
                        title: 'Overridden Accent Theme',
                        subtitle:
                            'Only this subtree receives the custom indigo styling.',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Inherited Wrapper (CardComponentTheme):',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: headerTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const CardComponentTheme(
                      data: successCardTheme,
                      child: WildCard(
                        title: 'Custom ComponentTheme Wrapper',
                        subtitle:
                            'Seamless integration using typed InheritedTheme hierarchy.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
      ),
    );
  }
}
