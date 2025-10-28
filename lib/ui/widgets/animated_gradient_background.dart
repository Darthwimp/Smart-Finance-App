import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final bool isDarkMode;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.isDarkMode,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
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
    final lightColors = [
      const [Color(0xFF6A85F1), Color(0xFF9D7CFD)],
      const [Color(0xFF74A9FF), Color(0xFFB693FF)],
      const [Color(0xFF5C7CFA), Color(0xFF8E8CFF)],
    ];

    final darkColors = [
      const [Color(0xFF0F172A), Color(0xFF1E3A8A)],
      const [Color(0xFF1E293B), Color(0xFF312E81)],
      const [Color(0xFF111827), Color(0xFF1E40AF)],
    ];

    final colors = widget.isDarkMode ? darkColors : lightColors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = (math.sin(_controller.value * math.pi * 2) + 1) / 2;
        final c1 = Color.lerp(colors[0][0], colors[1][0], t)!;
        final c2 = Color.lerp(colors[0][1], colors[1][1], t)!;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c1, c2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              if (!widget.isDarkMode)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
