import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool animated;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final defaultColors = colors ??
        (isDark
            ? [
                const Color(0xFF0A0E27),
                const Color(0xFF1A1F3A),
                primaryColor.withValues(alpha: 0.1),
              ]
            : [
                const Color(0xFFF5F7FA),
                const Color(0xFFE8EDF5),
                primaryColor.withValues(alpha: 0.05),
              ]);

    if (animated) {
      return AnimatedGradientBackground(
        colors: defaultColors,
        begin: begin,
        end: end,
        child: child,
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: defaultColors,
        ),
      ),
      child: child,
    );
  }
}

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.colors,
    required this.begin,
    required this.end,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = .new(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beginAlign = widget.begin as Alignment;
    final endAlign = widget.end as Alignment;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.lerp(
                beginAlign,
                endAlign,
                _animation.value * 0.3,
              )!,
              end: Alignment.lerp(
                endAlign,
                beginAlign,
                _animation.value * 0.3,
              )!,
              colors: widget.colors,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class MeshGradientBackground extends StatelessWidget {
  final Widget child;

  const MeshGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF0A0E27),
                      const Color(0xFF1A1F3A),
                    ]
                  : [
                      const Color(0xFFF5F7FA),
                      const Color(0xFFFFFFFF),
                    ],
            ),
          ),
        ),
        // Animated blobs
        Positioned(
          top: -100,
          right: -100,
          child: _AnimatedBlob(
            color: primary.withValues(alpha: isDark ? 0.1 : 0.08),
            duration: 6,
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: _AnimatedBlob(
            color: secondary.withValues(alpha: isDark ? 0.08 : 0.06),
            duration: 8,
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

class _AnimatedBlob extends StatefulWidget {
  final Color color;
  final int duration;

  const _AnimatedBlob({required this.color, required this.duration});

  @override
  State<_AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<_AnimatedBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = .new(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.2),
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color,
                  widget.color.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
