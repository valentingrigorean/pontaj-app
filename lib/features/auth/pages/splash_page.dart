import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;
  late final Animation<double> _jrOpacity;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _controller = .new(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _scale = Tween<double>(begin: 0.55, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.8, curve: Curves.easeOutBack),
      ),
    );
    _rotation = Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
    _jrOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );
    _glowOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Trigger auth check after animation
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<AuthBloc>().add(const AuthCheckRequested());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshGradientBackground(
        child: Stack(
          children: [
            ...List.generate(20, (index) => _FloatingParticle(index: index)),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final rotation = _rotation.value;
                  final jrOpacity = _jrOpacity.value;
                  final scale = _scale.value;
                  final progress = _controller.value;
                  final glowOpacity = _glowOpacity.value;

                  return Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: glowOpacity * 0.6,
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F8D6E)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 80,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _AnimatedLogo(
                              rotation: rotation,
                              jrOpacity: jrOpacity,
                              progress: progress,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Opacity(
                          opacity: jrOpacity,
                          child: Builder(
                            builder: (context) {
                              final l10n = AppLocalizations.of(context)!;
                              return Column(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [
                                        Color(0xFF0F8D6E),
                                        Color(0xFF0A6B54),
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      l10n.appTitle.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.appSubtitle,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 60),
                        Opacity(
                          opacity: jrOpacity,
                          child: SizedBox(
                            width: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor:
                                    Colors.grey[800]!.withValues(alpha: 0.2),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0F8D6E),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingParticle extends StatefulWidget {
  final int index;

  const _FloatingParticle({required this.index});

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _position;
  late double size;
  late double delay;

  @override
  void initState() {
    super.initState();
    final random = Random(widget.index);
    size = random.nextDouble() * 6 + 2;
    delay = random.nextDouble() * 2;

    _controller = .new(
      duration: Duration(seconds: 8 + random.nextInt(4)),
      vsync: this,
    );

    final startX = random.nextDouble() * 2 - 1;
    final endX = startX + (random.nextDouble() * 0.4 - 0.2);

    _position = Tween<Offset>(
      begin: Offset(startX, 1.2),
      end: Offset(endX, -0.2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    Future.delayed(Duration(milliseconds: (delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _position,
      builder: (context, child) {
        return Positioned(
          left:
              MediaQuery.of(context).size.width * (_position.value.dx + 1) / 2,
          top: MediaQuery.of(context).size.height * _position.value.dy,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFF0F8D6E).withValues(alpha: 0.4),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F8D6E).withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedLogo extends StatelessWidget {
  final double rotation;
  final double jrOpacity;
  final double progress;

  const _AnimatedLogo({
    required this.rotation,
    required this.jrOpacity,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: rotation,
            child: CustomPaint(
              painter: _JrLogoPainter(progress: progress.clamp(0, 1)),
              size: const Size.square(220),
            ),
          ),
          Opacity(
            opacity: jrOpacity,
            child: const Text(
              'JR',
              style: TextStyle(
                color: Colors.black,
                fontSize: 72,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JrLogoPainter extends CustomPainter {
  const _JrLogoPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) * 0.42;
    final center = size.center(Offset.zero);
    final startGap = pi / 6;
    final endGap = 12 * pi / 180;
    final gap = lerpDouble(startGap, endGap, progress) ?? endGap;
    const segments = 8;
    final sweep = (2 * pi / segments) - gap;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final stroke =
        lerpDouble(radius * 0.45, radius * 0.18, progress) ?? radius * 0.2;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double start = -pi / 2;
    for (int i = 0; i < segments; i++) {
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep + gap;
    }
  }

  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  bool shouldRepaint(covariant _JrLogoPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
