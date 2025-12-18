import 'package:flutter/material.dart';

class FadeInRight extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const FadeInRight({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.offset = 50.0,
  });

  @override
  _FadeInRightState createState() => _FadeInRightState();
}

class _FadeInRightState extends State<FadeInRight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset(widget.offset, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _positionAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
