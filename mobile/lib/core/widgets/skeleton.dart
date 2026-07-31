import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Drives a single shimmer animation for every [Skeleton] beneath it, so a
/// list of placeholders pulses in sync instead of each running its own clock.
class SkeletonTheme extends StatefulWidget {
  const SkeletonTheme({super.key, required this.child});

  final Widget child;

  @override
  State<SkeletonTheme> createState() => _SkeletonThemeState();
}

class _SkeletonThemeState extends State<SkeletonTheme>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SkeletonScope(animation: _controller, child: widget.child);
  }
}

class _SkeletonScope extends InheritedWidget {
  const _SkeletonScope({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_SkeletonScope oldWidget) =>
      oldWidget.animation != animation;
}

/// A shimmering placeholder block. Wrap a screen's placeholders in a
/// [SkeletonTheme] to share one animation; standalone use still animates.
class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppRadius.sm,
  });

  /// A pill-shaped placeholder standing in for a line of text.
  const Skeleton.line({super.key, this.width, this.height = 14})
      : radius = AppRadius.pill;

  const Skeleton.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = AppRadius.pill;

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final animation =
        context.dependOnInheritedWidgetOfExactType<_SkeletonScope>()?.animation;
    if (animation == null) {
      return _StandaloneSkeleton(width: width, height: height, radius: radius);
    }

    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          color: Color.lerp(
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.surfaceContainerHighest,
            animation.value,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: SizedBox(width: width, height: height),
      ),
    );
  }
}

/// Fallback used when no [SkeletonTheme] ancestor is present.
class _StandaloneSkeleton extends StatefulWidget {
  const _StandaloneSkeleton({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<_StandaloneSkeleton> createState() => _StandaloneSkeletonState();
}

class _StandaloneSkeletonState extends State<_StandaloneSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          color: Color.lerp(
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.surfaceContainerHighest,
            _controller.value,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: SizedBox(width: widget.width, height: widget.height),
      ),
    );
  }
}

/// Placeholder shaped like the app's standard list rows (leading avatar,
/// two text lines). Used while list screens load for the first time.
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Skeleton(width: 44, height: 44),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Skeleton.line(width: 140),
                  SizedBox(height: AppSpacing.sm),
                  Skeleton.line(width: 200, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A full-screen list of [SkeletonListTile]s, matching the padding used by
/// the real list so the transition does not jump.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screen),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, _) => const SkeletonListTile(),
      ),
    );
  }
}
