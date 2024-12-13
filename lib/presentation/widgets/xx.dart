import 'dart:math' as math;

import 'package:flutter/material.dart';

enum ParticleShape { circle, star, diamond }

class RisingParticles extends StatefulWidget {
  final int quantity;
  final List<Color> colors;
  final double maxSize;
  final double minSize;

  const RisingParticles({
    Key? key,
    this.quantity = 50,
    this.colors = const [
      Color(0xFF4C40BB),
     Color.fromARGB(255, 81, 9, 9),
     Colors.blue,
      Colors.red,
      Color(0xFF8157E8),
    ],
    this.maxSize = 8,
    this.minSize = 3,
  }) : super(key: key);

  @override
  State<RisingParticles> createState() => _RisingParticlesState();
}

class _RisingParticlesState extends State<RisingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<RisingParticle> particles = [];
  Size canvasSize = Size.zero;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _initParticles();
    _controller.addListener(() {
      _updateParticles();
      setState(() {});
    });
  }

  void _initParticles() {
    particles.clear();
    for (int i = 0; i < widget.quantity; i++) {
      particles.add(_createParticle());
    }
  }

RisingParticle _createParticle() {
  return RisingParticle(
    startX: random.nextDouble() * canvasSize.width,
    startY: canvasSize.height + random.nextDouble() * 20,
    size: random.nextDouble() * (widget.maxSize - widget.minSize) +
        widget.minSize,
    color: widget.colors[random.nextInt(widget.colors.length)],
    shape: ParticleShape.values[random.nextInt(ParticleShape.values.length)],
    progress: 0.0,
    speed: 0.001 + random.nextDouble() * 0.003, // Reduced speed range
  );
}


  void _updateParticles() {
    for (var particle in particles) {
      particle.progress += particle.speed;
      if (particle.progress >= 1.0) {
        particles[particles.indexOf(particle)] = _createParticle();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        return CustomPaint(
          painter: RisingParticlesPainter(particles: particles),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RisingParticlesPainter extends CustomPainter {
  final List<RisingParticle> particles;

  RisingParticlesPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()..color = particle.color.withOpacity(1.0 - particle.progress);
      canvas.drawCircle(Offset(particle.startX, particle.startY * (1 - particle.progress)), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RisingParticle {
  final double startX;
  final double startY;
  final double size;
  final Color color;
  final ParticleShape shape;
  double progress;
  final double speed;

  RisingParticle({
    required this.startX,
    required this.startY,
    required this.size,
    required this.color,
    required this.shape,
    required this.progress,
    required this.speed,
  });
}
