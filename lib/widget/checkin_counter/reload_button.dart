import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../common/style.dart';

class ReloadButton extends StatefulWidget {
  const ReloadButton(
      {required this.reload, required this.isLoading, super.key});

  final Function reload;
  final bool isLoading;

  @override
  State<ReloadButton> createState() => _ReloadBoxState();
}

class _ReloadBoxState extends State<ReloadButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      controller.stop();
    } else if (!oldWidget.isLoading && widget.isLoading) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(outsideShadowDistance),
      child: GestureDetector(
        onTap: () {
          debugPrint("isLoading ${widget.isLoading}");
          if (widget.isLoading) return;
          widget.reload();
          controller.repeat();
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: widget.isLoading
                ? null
                : [
                    BoxShadow(
                        offset: const Offset(
                            outsideShadowDistance, outsideShadowDistance),
                        color: downsideShadowColor,
                        blurRadius: outsideShadowDistance,
                        spreadRadius: 2),
                    const BoxShadow(
                        offset: Offset(
                            -outsideShadowDistance, -outsideShadowDistance),
                        color: upsideShadowColor,
                        blurRadius: outsideShadowDistance,
                        spreadRadius: 2)
                  ],
          ),
          child: Lottie.asset(
            'assets/animations/reload_animation.json',
            controller: controller,
            onLoaded: (composition) {
              controller.duration = composition.duration;
              controller.forward();
            },
            frameBuilder: (context, child, composition) {
              return ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(
                    darkBlueColor, BlendMode.srcATop),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
