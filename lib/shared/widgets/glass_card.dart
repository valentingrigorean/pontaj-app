import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double blur;
  final double opacity;
  final Color? color;
  final Border? border;
  final List<BoxShadow>? shadows;
  final bool enableBlur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.color,
    this.border,
    this.shadows,
    this.enableBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ??
        (isDark
            ? Colors.white.withValues(alpha: opacity)
            : Colors.white.withValues(alpha: opacity + 0.2));

    final innerContainer = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        border: border ?? Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.3),
          width: 1.5,
        ),
      ),
      child: child,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: shadows ?? [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        child: enableBlur
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: innerContainer,
              )
            : innerContainer,
      ),
    );
  }
}

enum GlassButtonVariant {
  /// Default glass effect with subtle background
  secondary,

  /// Accent-tinted glass with gradient border
  outlined,
}

class GlassButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? color;
  final bool enableBlur;
  final GlassButtonVariant variant;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.enableBlur = true,
    this.variant = GlassButtonVariant.secondary,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = .new(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final radius = widget.borderRadius ?? 12;

    // Determine colors based on variant
    Color backgroundColor;
    Border border;
    List<BoxShadow> shadows;

    switch (widget.variant) {
      case GlassButtonVariant.outlined:
        // Accent-tinted with gradient-like border
        backgroundColor = widget.color ??
            (isDark
                ? primaryColor.withValues(alpha: 0.08)
                : primaryColor.withValues(alpha: 0.05));
        border = Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
          width: 1.5,
        );
        shadows = [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
        break;
      case GlassButtonVariant.secondary:
        // Improved secondary with better contrast
        backgroundColor = widget.color ??
            (isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.shade100.withValues(alpha: 0.8));
        border = Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.grey.shade300.withValues(alpha: 0.8),
          width: 1.0,
        );
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
        break;
    }

    final innerContainer = Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: widget.enableBlur
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: innerContainer,
                )
              : innerContainer,
        ),
      ),
    );
  }
}
