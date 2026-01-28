import 'package:flutter/material.dart';
import '../theme/app_radii.dart';

class AppSkeleton extends StatefulWidget {
  final double height;
  final double width;
  const AppSkeleton({super.key, required this.height, required this.width});

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surface;
    final hi = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.55);

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        final c = Color.lerp(base, hi, t)!;

        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        );
      },
    );
  }
}
