import 'package:flutter/material.dart';

class AnimatedCountText extends StatefulWidget {
  const AnimatedCountText(
      {required this.count, required this.duration, super.key});

  final int count;
  final int duration;

  @override
  State<AnimatedCountText> createState() => _AnimatedCountTextState();
}

class _AnimatedCountTextState extends State<AnimatedCountText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration), // 애니메이션 지속 시간 조정
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.count.toDouble())
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_animation.value.toInt()} 명',
      style: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
