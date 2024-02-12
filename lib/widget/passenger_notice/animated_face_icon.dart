import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../common/style.dart';

class AnimatedFaceIcon extends StatefulWidget {
  const AnimatedFaceIcon({required this.delay, required this.icon, super.key});

  final int delay;
  final IconData icon;

  @override
  State<AnimatedFaceIcon> createState() => _AnimatedFaceIconState();
}

class _AnimatedFaceIconState extends State<AnimatedFaceIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool didStart = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // 애니메이션 지속 시간 조정
      vsync: this,
    );

    final curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    _animation = Tween<double>(begin: -5, end: 0).animate(curvedAnimation);

    Future.delayed(Duration(seconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
      setState(() {
        didStart = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
                offset: Offset(0, _animation.value * 20), child: child);
          },
          child: SizedBox(
              width: 100,
              height: 100,
              child: didStart
                  ? FittedBox(
                      child: FaIcon(widget.icon, color: lightestBlueColor))
                  : Container()));
    });
  }
}
