import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class OnboardingPageThree extends StatelessWidget {
  final Animation<Offset> lampAnimation;
  final Animation<Offset> imageAnimation;
  final Animation<Offset> textAnimation;
  final Animation<Offset> subtitleAnimation;
  final Animation<Offset> treeAnimation;
  final AnimationController textController;
  final AnimationController subtitleController;

  const OnboardingPageThree({
    super.key,
    required this.lampAnimation,
    required this.imageAnimation,
    required this.textAnimation,
    required this.subtitleAnimation,
    required this.treeAnimation,
    required this.textController,
    required this.subtitleController,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
