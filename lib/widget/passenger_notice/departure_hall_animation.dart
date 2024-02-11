import 'dart:math';

import 'package:flutter/material.dart';

class DepartureHallAnimation extends StatefulWidget {
  const DepartureHallAnimation(
      {super.key, required this.isLoading, this.passengerCnt});

  final bool isLoading;
  final String? passengerCnt;

  @override
  State<DepartureHallAnimation> createState() => _DepartureHallAnimationState();
}

class _DepartureHallAnimationState extends State<DepartureHallAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = [];
  late final List<Animation<double>> _animations = [];
  final int _cloudCount = 10;
  final List<double> _cloudHeights = [];
  final List<double> _cloudScaleFactors = [];

  late final AnimationController _characterController;
  late final Animation<double> _characterAnimation;

  @override
  void initState() {
    super.initState();
    Random random = Random();
    for (int i = 1; i <= _cloudCount; i++) {
      var controller = AnimationController(
        duration: const Duration(seconds: 30),
        vsync: this,
      )..repeat(reverse: false);
      _controllers.add(controller);

      final curvedAnimation = CurvedAnimation(
        parent: controller,
        curve: Interval(
            1 / (_cloudCount + 1) * (i - 1), 1 / (_cloudCount + 1) * (i + 1)),
      );

      var animation = Tween(begin: 1.0, end: -0.5).animate(curvedAnimation);
      _animations.add(animation);

      _cloudHeights.add(random.nextDouble());
      _cloudScaleFactors.add(random.nextDouble());
    }

    _characterController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    final characterCurvedAnimation =
        CurvedAnimation(parent: _characterController, curve: Curves.ease);

    _characterAnimation = Tween(
      begin: 1.0,
      end: -1.0,
    ).animate(characterCurvedAnimation);
  }

  @override
  void dispose() {
    for (AnimationController controller in _controllers) {
      controller.dispose();
    }
    _characterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double stackHeight = 250;
    double stackWidth = MediaQuery.of(context).size.width;
    double characterHeight = 120;
    double characterWidth = 120;

    double? passengerCnt =
        widget.passengerCnt != null ? double.parse(widget.passengerCnt!) : null;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/dawn.png'), fit: BoxFit.fill)),
      width: stackWidth,
      height: stackHeight,
      child: Stack(
        children: [
          if (!widget.isLoading && passengerCnt != null)
          for (int i = 0; i < _cloudCount; i += 2)
              _buildAnimatedCloud(i, stackHeight, passengerCnt),
          AnimatedBuilder(
              animation: _characterAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      stackWidth / 2 - characterWidth / 2,
                      stackHeight / 2 -
                          characterHeight / 2 +
                          _characterAnimation.value * 20),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/character.png',
                width: characterWidth,
                height: characterHeight,
              )),
          if (!widget.isLoading && passengerCnt != null)
          for (int i = 1; i < _cloudCount; i += 2)
              _buildAnimatedCloud(i, stackHeight, passengerCnt),
        ],
      ),
    );
  }

  Widget _buildAnimatedCloud(
      int index, double stackHeight, double passengerCnt) {
    double imageHeight = 100;

    Color? color =
        passengerCnt < 60000 ? null : const Color.fromARGB(255, 22, 55, 80);
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        double screenHeight = stackHeight - imageHeight;
        double verticalPosition = _cloudHeights[index] * screenHeight;
        return Transform.translate(
          offset: Offset(
              _animations[index].value * MediaQuery.of(context).size.width,
              verticalPosition),
          child: child,
        );
      },
      child: Transform.scale(
          scale: 0.5 + _cloudScaleFactors[index] / 2,
          child: Image.asset(
            'assets/images/white_cloud.png',
            height: imageHeight,
            fit: BoxFit.fitHeight,
            colorBlendMode: BlendMode.modulate,
            color: color,
          )),
    );
  }
}
