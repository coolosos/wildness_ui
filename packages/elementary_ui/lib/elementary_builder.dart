part of 'elementary.dart';

typedef ValueElementaryBuilder = Widget Function(
  BuildContext context,
  Elementary themeData,
);

class ElementaryBuilder extends StatelessWidget {
  const ElementaryBuilder({
    required this.builder,
    super.key,
  });

  final ValueElementaryBuilder builder;

  @override
  Widget build(BuildContext context) {
    final elementary = Elementary.of(context, listen: true);
    return builder.call(context, elementary);
  }
}
