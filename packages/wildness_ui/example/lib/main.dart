import 'package:wildness_ui/wildness.dart';

// =============================================================================
// 1. Base Theme & Kinds (Variants)
// =============================================================================

/// Base theme data containing common properties, [copyWith], and [lerp].
///
/// Subclasses only need to implement [create] to instantiate their concrete type,
/// avoiding code duplication across different kinds.
abstract base class ButtonThemeData<T extends ButtonThemeData<T>>
    extends WildnessBase<T> {
  const new({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  /// Factory method to instantiate the concrete kind [T].
  T create({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderRadius,
    EdgeInsetsGeometry padding,
  });

  @override
  T copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return create(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  T lerp(WildnessBase<T>? other, double t) {
    if (other is! ButtonThemeData<T>) return this as T;
    return create(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius: borderRadius + (other.borderRadius - borderRadius) * t,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        textColor,
        borderColor,
        borderRadius,
        padding,
      ];
}

/// Kind: Primary button variant.
final class PrimaryButtonThemeData
    extends ButtonThemeData<PrimaryButtonThemeData> {
  const new({
    required super.backgroundColor,
    required super.textColor,
    super.borderColor,
    super.borderRadius,
    super.padding,
  });

  @override
  PrimaryButtonThemeData create({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderRadius = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
  }) {
    return PrimaryButtonThemeData(
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}

/// Kind: Secondary button variant.
final class SecondaryButtonThemeData
    extends ButtonThemeData<SecondaryButtonThemeData> {
  const new({
    required super.backgroundColor,
    required super.textColor,
    super.borderColor,
    super.borderRadius,
    super.padding,
  });

  @override
  SecondaryButtonThemeData create({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderRadius = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
  }) {
    return SecondaryButtonThemeData(
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}

// =============================================================================
// 2. Component Widget (Generic Kind T, Zero Material Dependencies)
// =============================================================================

class WildButton<K extends ButtonThemeData<K>> extends StatelessWidget {
  const new({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Resolve the theme data for generic kind K directly from the Wildness theme tree
    final theme = ComponentTheme.kindThemeData<K>(context);
    final backgroundColor = theme?.backgroundColor ?? const Color(0xFF2563EB);
    final textColor = theme?.textColor ?? const Color(0xFFFFFFFF);
    final borderColor = theme?.borderColor;
    final borderRadius = theme?.borderRadius ?? 8.0;
    final padding = theme?.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 3. Application Setup (WildnessApp + Pure WidgetsApp)
// =============================================================================

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
    // 1. Light mode tokens for both kinds
    const lightPrimary = PrimaryButtonThemeData(
      backgroundColor: Color(0xFF2563EB),
      textColor: Color(0xFFFFFFFF),
    );
    const lightSecondary = SecondaryButtonThemeData(
      backgroundColor: Color(0x00000000),
      textColor: Color(0xFF2563EB),
      borderColor: Color(0xFF2563EB),
    );

    // 2. Dark mode tokens for both kinds
    const darkPrimary = PrimaryButtonThemeData(
      backgroundColor: Color(0xFF3B82F6),
      textColor: Color(0xFFFFFFFF),
    );
    const darkSecondary = SecondaryButtonThemeData(
      backgroundColor: Color(0x00000000),
      textColor: Color(0xFF93C5FD),
      borderColor: Color(0xFF3B82F6),
    );

    // 3. Register tokens in WildnessProperties
    final wildnessProperties = WildnessProperties(
      forceThemeMode: _brightness,
      components: const Configuration(
        light: [lightPrimary, lightSecondary],
        dark: [darkPrimary, darkSecondary],
      ),
    );

    final isDark = _brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB);
    final titleColor =
        isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return WildnessApp(
      wildnessProperties: wildnessProperties,
      child: WidgetsApp(
        title: 'Wildness UI Basic Example',
        color: const Color(0xFF2563EB),
        debugShowCheckedModeBanner: false,
        pageRouteBuilder: <T>(settings, builder) {
          return PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                builder(context),
          );
        },
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            color: backgroundColor,
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Wildness UI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'One component (WildButton<T>) parameterized by theme kind',
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Kind 1: Primary Button Kind
                    WildButton<PrimaryButtonThemeData>(
                      label: 'Primary Button',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    // Kind 2: Secondary Button Kind
                    WildButton<SecondaryButtonThemeData>(
                      label: 'Secondary Button',
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),

                    // Theme toggle using Secondary Button Kind
                    WildButton<SecondaryButtonThemeData>(
                      label: isDark
                          ? '☀ Switch to Light Mode'
                          : '🌙 Switch to Dark Mode',
                      onTap: _toggleTheme,
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
