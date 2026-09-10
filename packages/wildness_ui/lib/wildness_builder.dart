part of 'wildness.dart';

typedef ValueWildnessBuilder = Widget Function(
  BuildContext context,
  Wildness themeData,
);

final class WildnessBuilder extends StatelessWidget {
  const new({required this.builder, super.key});

  final ValueWildnessBuilder builder;

  @override
  Widget build(BuildContext context) {
    final wildness = Wildness.of(context, listen: true);
    return builder(context, wildness);
  }
}
