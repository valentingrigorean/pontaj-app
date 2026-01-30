import 'dart:math';
import 'package:flutter/material.dart';

/// Particle explosion effect for dramatic visual feedback
class ParticleExplosion extends StatefulWidget {
  final bool isExploding;
  final Widget child;
  final Color particleColor;
  final int particleCount;

  const ParticleExplosion({
    super.key,
    required this.isExploding,
    required this.child,
    this.particleColor = Colors.orange,
    this.particleCount = 30,
  });

  @override
  State<ParticleExplosion> createState() => _ParticleExplosionState();
}

class _ParticleExplosionState extends State<ParticleExplosion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(ParticleExplosion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExploding && !oldWidget.isExploding) {
      _createParticles();
      _controller.forward(from: 0);
    }
  }

  void _createParticles() {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      final angle = (i / widget.particleCount) * 2 * pi;
      final speed = _random.nextDouble() * 200 + 100;

      _particles.add(_Particle(
        color: widget.particleColor,
        angle: angle,
        speed: speed,
        size: _random.nextDouble() * 6 + 3,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isExploding && _controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ParticleExplosionPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  final Color color;
  final double angle;
  final double speed;
  final double size;

  _Particle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
  });
}

class _ParticleExplosionPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticleExplosionPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final distance = particle.speed * progress;
      final x = center.dx + cos(particle.angle) * distance;
      final y = center.dy + sin(particle.angle) * distance;

      final opacity = (1 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticleExplosionPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Success burst effect - stars shooting outward
class SuccessBurst extends StatefulWidget {
  final bool show;
  final Widget child;

  const SuccessBurst({
    super.key,
    required this.show,
    required this.child,
  });

  @override
  State<SuccessBurst> createState() => _SuccessBurstState();
}

class _SuccessBurstState extends State<SuccessBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didUpdateWidget(SuccessBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.show && _controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _StarBurstPainter(progress: _controller.value),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _StarBurstPainter extends CustomPainter {
  final double progress;

  _StarBurstPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final starCount = 8;

    for (int i = 0; i < starCount; i++) {
      final angle = (i / starCount) * 2 * pi;
      final distance = progress * 100;
      final x = center.dx + cos(angle) * distance;
      final y = center.dy + sin(angle) * distance;

      final opacity = (1 - progress).clamp(0.0, 1.0);
      final size = 20 * (1 - progress * 0.5);

      final paint = Paint()
        ..color = Colors.amber.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      _drawStar(canvas, Offset(x, y), size, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final points = 5;
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
