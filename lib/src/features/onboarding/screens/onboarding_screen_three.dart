import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/onboarding/scan_line.dart';
import 'package:decora/src/features/onboarding/widgets/corners_painter.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingPageThree extends StatefulWidget {
  const OnboardingPageThree({super.key});

  @override
  State<OnboardingPageThree> createState() => _OnboardingPageThreeState();
}

class _OnboardingPageThreeState extends State<OnboardingPageThree>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _textController;
  late AnimationController _successController;
  late AnimationController _cornerFadeController;

  late Animation<double> _scanOpacity;
  late Animation<double> _scanLinePosition;
  late Animation<double> _successFade;
  late Animation<double> _cornerOpacity;
  late Animation<Offset> _textSlide;

  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _cornerFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _scanOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _scanController, curve: Curves.easeIn));

    _scanLinePosition = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _cornerOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _cornerFadeController, curve: Curves.easeOut),
    );

    _successFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successController, curve: Curves.easeIn),
    );

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _textController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    for (int i = 0; i < 2; i++) {
      await _scanController.forward();
      await _scanController.reverse();
    }

    await _cornerFadeController.forward();

    await _successController.forward();
    setState(() => _showSuccess = true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _textController.dispose();
    _successController.dispose();
    _cornerFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: SlideTransition(
                  position: _textSlide,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See Before You Buy',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightMainText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Use our AR feature to place furniture in your own room and preview how it looks instantly. Shop with confidence knowing every item fits your space and style.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.lightSecondaryText,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 1.80,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 180),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      Assets.onBoarding3,
                      height: 390,
                      fit: BoxFit.contain,
                    ),

                    FadeTransition(
                      opacity: _cornerOpacity,
                      child: CustomPaint(
                        painter: CornersPainter(),
                        size: const Size(200, 350),
                      ),
                    ),

                    FadeTransition(
                      opacity: _scanOpacity,
                      child: AnimatedBuilder(
                        animation: _scanLinePosition,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: ScanLinePainter(_scanLinePosition.value),
                            size: const Size(200, 280),
                          );
                        },
                      ),
                    ),

                    if (_showSuccess)
                      FadeTransition(
                        opacity: _successFade,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.lightBackground,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Scanned Successful!',
                              style: TextStyle(
                                color: AppColors.lightBackground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
