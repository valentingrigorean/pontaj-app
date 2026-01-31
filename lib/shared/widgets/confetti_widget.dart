import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  final bool isCelebrating;
  final Widget child;

  const ConfettiWidget({
    super.key,
    required this.isCelebrating,
    required this.child,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = .new(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCelebrating && !oldWidget.isCelebrating) {
      _createConfetti();
      _controller.forward(from: 0);
    }
  }

  void _createConfetti() {
    _particles.clear();
    for (int i = 0; i < 100; i++) {
      _particles.add(_ConfettiParticle(
        color: _randomColor(),
        startX: _random.nextDouble(),
        startY: _random.nextDouble() * 0.3,
        velocityX: (_random.nextDouble() - 0.5) * 2,
        velocityY: -(_random.nextDouble() * 2 + 1),
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        size: _random.nextDouble() * 8 + 4,
      ));
    }
  }

  Color _randomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];
    return colors[_random.nextInt(colors.length)];
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
        if (widget.isCelebrating && _controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
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

class _ConfettiParticle {
  final Color color;
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double rotationSpeed;
  final double size;

  _ConfettiParticle({
    required this.color,
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const gravity = 2.0;

    for (final particle in particles) {
      final x = size.width * particle.startX + particle.velocityX * size.width * progress * 0.5;
      final y = size.height * particle.startY +
                 particle.velocityY * size.height * progress * 0.3 +
                 gravity * size.height * progress * progress * 0.5;

      if (y > size.height) continue;

      final rotation = particle.rotation + particle.rotationSpeed * progress;
      final opacity = (1 - progress).clamp(0.0, 1.0);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 1.5,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Trigger confetti easily
class ConfettiController extends ChangeNotifier {
  bool _isCelebrating = false;

  bool get isCelebrating => _isCelebrating;

  void celebrate() {
    _isCelebrating = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 100), () {
      _isCelebrating = false;
      notifyListeners();
    });
  }
}
