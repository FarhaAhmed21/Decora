import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class OnboardingPageOne extends StatelessWidget {
  final Animation<Offset> lampAnimation;
  final Animation<Offset> imageAnimation;
  final Animation<Offset> textAnimation;
  final Animation<Offset> subtitleAnimation;
  final Animation<Offset> treeAnimation;
  final AnimationController textController;
  final AnimationController subtitleController;

  const OnboardingPageOne({
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -50,
          right: -103,
          child: SlideTransition(
            position: lampAnimation,
            child: Image.asset(
              'assets/images/lamp.png',
              width: 335,
              height: 396,
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: 0,
          child: SlideTransition(
            position: treeAnimation,
            child: Image.asset(
              'assets/images/tree.png',
              width: 150,
              height: 450,
            ),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 80,
          child: SlideTransition(
            position: imageAnimation,
            child: Image.asset(
              'assets/images/onboarding1.png',
              width: 340,
              height: 340,
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              SlideTransition(
                position: textAnimation,
                child: FadeTransition(
                  opacity: textController,
                  child: const Text(
                    "Find Your Perfect Style",
                    style: TextStyle(
                      color: AppColors.lightMainText,
                      fontSize: 32,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: -0.64,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 12),
              SlideTransition(
                position: subtitleAnimation,
                child: FadeTransition(
                  opacity: subtitleController,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "Explore a wide collection of modern and classic furniture pieces, carefully designed to bring comfort and elegance into every corner of your home.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.lightSecondaryText,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 1.80,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
