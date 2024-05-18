part of 'wildness.dart';

typedef ValueWildnessBuilder = Widget Function(
  BuildContext context,
  Wildness themeData,
);

class WildnessBuilder extends StatelessWidget {
  const WildnessBuilder({
    required this.builder,
    super.key,
  });

  final ValueWildnessBuilder builder;

  @override
  Widget build(BuildContext context) {
    final wildness = Wildness.of(context, listen: true);
    return builder.call(context, wildness);
  }
}
