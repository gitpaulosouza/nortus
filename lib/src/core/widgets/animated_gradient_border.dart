import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final List<Color> gradientColors;
  final BorderRadiusGeometry borderRadius;
  final int animationDuration;
  final double borderWidth;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.animationDuration = 3,
    this.borderWidth = 2,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.animationDuration),
    );

    _controller.repeat();
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
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(_controller.value * 2 * math.pi - math.pi / 2),
                math.sin(_controller.value * 2 * math.pi - math.pi / 2),
              ),
              end: Alignment(
                math.cos(_controller.value * 2 * math.pi + math.pi / 2),
                math.sin(_controller.value * 2 * math.pi + math.pi / 2),
              ),
              colors: widget.gradientColors,
              stops: const [0.0, 1.0],
            ),
          ),
          padding: EdgeInsets.all(widget.borderWidth),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: Colors.white,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

