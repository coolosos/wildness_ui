import 'package:wildness_ui/wildness.dart';

// ===========================================================================
// STEP 1: Define Base Theme and Kinds (Variants) using F-Bounded Polymorphism
// ===========================================================================

/// Base class defining common properties for all Button kinds.
abstract base class ButtonThemeData<T extends ButtonThemeData<T>>
    extends WildnessBase<T> {
  const new({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

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
  PrimaryButtonThemeData copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return PrimaryButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  PrimaryButtonThemeData lerp(
    WildnessBase<PrimaryButtonThemeData>? other,
    double t,
  ) {
    if (other is! PrimaryButtonThemeData) return this;
    return PrimaryButtonThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
    );
  }
}

/// Kind: Secondary button variant (outline style).
final class SecondaryButtonThemeData
    extends ButtonThemeData<SecondaryButtonThemeData> {
  const new({
    required super.backgroundColor,
    required super.textColor,
    required super.borderColor,
    super.borderRadius,
    super.padding,
  });

  @override
  SecondaryButtonThemeData copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return SecondaryButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  SecondaryButtonThemeData lerp(
    WildnessBase<SecondaryButtonThemeData>? other,
    double t,
  ) {
    if (other is! SecondaryButtonThemeData) return this;
    return SecondaryButtonThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
    );
  }
}

/// Kind: Danger / Destructive button variant.
final class DangerButtonThemeData
    extends ButtonThemeData<DangerButtonThemeData> {
  const new({
    required super.backgroundColor,
    required super.textColor,
    super.borderColor,
    super.borderRadius,
    super.padding,
  });

  @override
  DangerButtonThemeData copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return DangerButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  DangerButtonThemeData lerp(
    WildnessBase<DangerButtonThemeData>? other,
    double t,
  ) {
    if (other is! DangerButtonThemeData) return this;
    return DangerButtonThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
    );
  }
}

// ---------------------------------------------------------------------------

/// Base class defining common properties for all Card kinds.
abstract base class CardThemeData<T extends CardThemeData<T>>
    extends WildnessBase<T> {
  const new({
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.bodyColor,
    this.borderRadius = 12.0,
    this.borderWidth = 1.0,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color bodyColor;
  final double borderRadius;
  final double borderWidth;

  @override
  List<Object?> get props => [
        backgroundColor,
        borderColor,
        titleColor,
        bodyColor,
        borderRadius,
        borderWidth,
      ];
}

/// Kind: Standard card variant.
final class StandardCardThemeData extends CardThemeData<StandardCardThemeData> {
  const new({
    required super.backgroundColor,
    required super.borderColor,
    required super.titleColor,
    required super.bodyColor,
    super.borderRadius,
    super.borderWidth,
  });

  @override
  StandardCardThemeData copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? titleColor,
    Color? bodyColor,
    double? borderRadius,
    double? borderWidth,
  }) {
    return StandardCardThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      titleColor: titleColor ?? this.titleColor,
      bodyColor: bodyColor ?? this.bodyColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  StandardCardThemeData lerp(
    WildnessBase<StandardCardThemeData>? other,
    double t,
  ) {
    if (other is! StandardCardThemeData) return this;
    return StandardCardThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      borderColor:
          Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      titleColor: Color.lerp(titleColor, other.titleColor, t) ?? titleColor,
      bodyColor: Color.lerp(bodyColor, other.bodyColor, t) ?? bodyColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      borderWidth:
          borderWidth + (other.borderWidth - borderWidth) * t,
    );
  }
}

/// Kind: Featured / Highlighted card variant.
final class FeaturedCardThemeData extends CardThemeData<FeaturedCardThemeData> {
  const new({
    required super.backgroundColor,
    required super.borderColor,
    required super.titleColor,
    required super.bodyColor,
    super.borderRadius = 16.0,
    super.borderWidth = 2.0,
  });

  @override
  FeaturedCardThemeData copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? titleColor,
    Color? bodyColor,
    double? borderRadius,
    double? borderWidth,
  }) {
    return FeaturedCardThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      titleColor: titleColor ?? this.titleColor,
      bodyColor: bodyColor ?? this.bodyColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  FeaturedCardThemeData lerp(
    WildnessBase<FeaturedCardThemeData>? other,
    double t,
  ) {
    if (other is! FeaturedCardThemeData) return this;
    return FeaturedCardThemeData(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      borderColor:
          Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      titleColor: Color.lerp(titleColor, other.titleColor, t) ?? titleColor,
      bodyColor: Color.lerp(bodyColor, other.bodyColor, t) ?? bodyColor,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      borderWidth:
          borderWidth + (other.borderWidth - borderWidth) * t,
    );
  }
}

// ===========================================================================
// STEP 2: Create Pure UI Widgets with Zero Material Dependencies
// ===========================================================================

enum ButtonKind { primary, secondary, danger }

class WildButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onTap,
    this.kind = ButtonKind.primary,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final ButtonKind kind;

  @override
  Widget build(BuildContext context) {
    // Resolve the appropriate kind token from the Wildness theme tree
    final ButtonThemeData<dynamic> theme = switch (kind) {
      ButtonKind.danger =>
        ComponentTheme.kindThemeData<DangerButtonThemeData>(context) ??
            const DangerButtonThemeData(
              backgroundColor: Color(0xFFEF4444),
              textColor: Color(0xFFFFFFFF),
            ),
      ButtonKind.secondary =>
        ComponentTheme.kindThemeData<SecondaryButtonThemeData>(context) ??
            const SecondaryButtonThemeData(
              backgroundColor: Color(0x00000000),
              textColor: Color(0xFF3B82F6),
              borderColor: Color(0xFF3B82F6),
            ),
      ButtonKind.primary =>
        ComponentTheme.kindThemeData<PrimaryButtonThemeData>(context) ??
            const PrimaryButtonThemeData(
              backgroundColor: Color(0xFF3B82F6),
              textColor: Color(0xFFFFFFFF),
            ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: theme.padding,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          border: theme.borderColor != null
              ? Border.all(color: theme.borderColor!, width: 1.5)
              : null,
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
    this.badge,
    this.isFeatured = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? badge;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    // Resolves FeaturedCardThemeData or StandardCardThemeData automatically
    final CardThemeData<dynamic> theme = isFeatured
        ? ComponentTheme.kindThemeData<FeaturedCardThemeData>(context) ??
            const FeaturedCardThemeData(
              backgroundColor: Color(0xFF312E81),
              borderColor: Color(0xFF6366F1),
              titleColor: Color(0xFFEEF2FF),
              bodyColor: Color(0xFFC7D2FE),
            )
        : ComponentTheme.kindThemeData<StandardCardThemeData>(context) ??
            const StandardCardThemeData(
              backgroundColor: Color(0xFFFFFFFF),
              borderColor: Color(0xFFE5E7EB),
              titleColor: Color(0xFF111827),
              bodyColor: Color(0xFF6B7280),
            );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.borderColor, width: theme.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.borderColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: theme.titleColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
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

// ===========================================================================
// STEP 3: Configure Wildness Theme with Light and Dark Token Palettes
// ===========================================================================

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
    // 1. Light Mode Tokens for all Kinds
    const lightPrimaryBtn = PrimaryButtonThemeData(
      backgroundColor: Color(0xFF2563EB),
      textColor: Color(0xFFFFFFFF),
    );
    const lightSecondaryBtn = SecondaryButtonThemeData(
      backgroundColor: Color(0x00000000),
      textColor: Color(0xFF2563EB),
      borderColor: Color(0xFF2563EB),
    );
    const lightDangerBtn = DangerButtonThemeData(
      backgroundColor: Color(0xFFDC2626),
      textColor: Color(0xFFFFFFFF),
    );

    const lightStandardCard = StandardCardThemeData(
      backgroundColor: Color(0xFFF9FAFB),
      borderColor: Color(0xFFE5E7EB),
      titleColor: Color(0xFF111827),
      bodyColor: Color(0xFF4B5563),
    );
    const lightFeaturedCard = FeaturedCardThemeData(
      backgroundColor: Color(0xFFEEF2FF),
      borderColor: Color(0xFF6366F1),
      titleColor: Color(0xFF312E81),
      bodyColor: Color(0xFF4338CA),
    );

    // 2. Dark Mode Tokens for all Kinds
    const darkPrimaryBtn = PrimaryButtonThemeData(
      backgroundColor: Color(0xFF3B82F6),
      textColor: Color(0xFFFFFFFF),
    );
    const darkSecondaryBtn = SecondaryButtonThemeData(
      backgroundColor: Color(0x00000000),
      textColor: Color(0xFF93C5FD),
      borderColor: Color(0xFF3B82F6),
    );
    const darkDangerBtn = DangerButtonThemeData(
      backgroundColor: Color(0xFFEF4444),
      textColor: Color(0xFFFFFFFF),
    );

    const darkStandardCard = StandardCardThemeData(
      backgroundColor: Color(0xFF1F2937),
      borderColor: Color(0xFF374151),
      titleColor: Color(0xFFF9FAFB),
      bodyColor: Color(0xFF9CA3AF),
    );
    const darkFeaturedCard = FeaturedCardThemeData(
      backgroundColor: Color(0xFF1E1B4B),
      borderColor: Color(0xFF818CF8),
      titleColor: Color(0xFFE0E7FF),
      bodyColor: Color(0xFFC7D2FE),
    );

    // 3. Assemble all Component Kinds into WildnessProperties
    final wildnessProperties = WildnessProperties(
      forceThemeMode: _brightness,
      components: const Configuration(
        light: [
          lightPrimaryBtn,
          lightSecondaryBtn,
          lightDangerBtn,
          lightStandardCard,
          lightFeaturedCard,
        ],
        dark: [
          darkPrimaryBtn,
          darkSecondaryBtn,
          darkDangerBtn,
          darkStandardCard,
          darkFeaturedCard,
        ],
      ),
    );

    final isDark = _brightness == Brightness.dark;
    final surfaceBg = isDark ? const Color(0xFF111827) : const Color(0xFFFFFFFF);
    final headerColor = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);

    return WildnessApp(
      wildnessProperties: wildnessProperties,
      child: WidgetsApp(
        title: 'Wildness UI Multi-Kind Showcase',
        color: const Color(0xFF2563EB),
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            color: surfaceBg,
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Wildness UI',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: headerColor,
                          ),
                        ),
                        WildButton(
                          label: isDark ? '☀ Light' : '🌙 Dark',
                          kind: ButtonKind.secondary,
                          onTap: _toggleTheme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Section 1: Button Kinds
                    Text(
                      'BUTTON KINDS (Variants):',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: headerColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: WildButton(
                            label: 'Primary',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: WildButton(
                            label: 'Secondary',
                            kind: ButtonKind.secondary,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: WildButton(
                            label: 'Danger',
                            kind: ButtonKind.danger,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Section 2: Card Kinds
                    Text(
                      'CARD KINDS (Variants):',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: headerColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const WildCard(
                      title: 'Standard Card',
                      subtitle:
                          'A default clean card consuming StandardCardThemeData.',
                      badge: 'Base',
                    ),
                    const SizedBox(height: 12),
                    const WildCard(
                      title: 'Featured Card',
                      subtitle:
                          'Specialized kind consuming FeaturedCardThemeData with custom borders and accent colors.',
                      isFeatured: true,
                      badge: 'Kind',
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
