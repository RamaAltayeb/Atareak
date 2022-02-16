import 'package:flutter/material.dart';

class AnimatedGlow extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  const AnimatedGlow({this.child, this.colors});
  @override
  _AnimatedGlowState createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<AnimatedGlow>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, outPutWidget) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: widget.colors,
              stops: [
                _animationController.value - 0.3,
                _animationController.value,
                _animationController.value + 0.3
              ],
            ).createShader(
              Rect.fromLTRB(rect.width, rect.height, 0, 0),
            );
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }
}
