import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingPageTwo extends StatefulWidget {
  const OnboardingPageTwo({super.key});

  @override
  State<OnboardingPageTwo> createState() => _OnboardingPageTwoState();
}

class _OnboardingPageTwoState extends State<OnboardingPageTwo>
    with TickerProviderStateMixin {
  late AnimationController _chairController;
  late AnimationController _textController;
  late AnimationController _rectangleController;
  late AnimationController _lineTextController;
  late AnimationController _lineTextController2;

  late Animation<Offset> _chairSlide;
  late Animation<Offset> _textSlide;
  late Animation<double> _rectangleFade;
  late Animation<Offset> _line1Slide;
  late Animation<Offset> _line2Slide;
  late Animation<Offset> _line3Slide;
  late Animation<Offset> _line1Slide2;
  late Animation<Offset> _line2Slide2;

  bool _animationsPlayed = false;

  @override
  void initState() {
    super.initState();

    int duration = 900;
    _chairController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );

    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );

    _rectangleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );

    _chairSlide = Tween<Offset>(
      begin: const Offset(-1.8, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _chairController, curve: Curves.easeOut));

    _textSlide = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _rectangleFade =
        TweenSequence([
          TweenSequenceItem(tween: ConstantTween(0.0), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 70),
        ]).animate(
          CurvedAnimation(
            parent: _rectangleController,
            curve: Curves.easeInOut,
          ),
        );

    _lineTextController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );

    _line1Slide = Tween<Offset>(begin: const Offset(3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _lineTextController,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
          ),
        );

    _line2Slide = Tween<Offset>(begin: const Offset(3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _lineTextController,
            curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
          ),
        );

    _line3Slide = Tween<Offset>(begin: const Offset(3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _lineTextController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
          ),
        );

    _lineTextController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );

    _line1Slide2 = Tween<Offset>(begin: const Offset(-3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _lineTextController,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
          ),
        );

    _line2Slide2 = Tween<Offset>(begin: const Offset(-3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _lineTextController,
            curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
          ),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_animationsPlayed) {
      _animationsPlayed = true;
      _playAnimations();
    }
  }

  Future<void> _playAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _chairController.forward();
    await _textController.forward();
    await _rectangleController.forward();
    await _lineTextController.forward();
    await _lineTextController2.forward();
  }

  @override
  void dispose() {
    _chairController.dispose();
    _textController.dispose();
    _rectangleController.dispose();
    _lineTextController.dispose();
    _lineTextController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 120),
                child: SlideTransition(
                  position: _chairSlide,
                  child: Image.asset(Assets.onboarding2, height: 360),
                ),
              ),
            ),

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
                        'Made Just For You',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 32,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          height: 1,
                          letterSpacing: -0.64,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Get smart recommendations tailored to your lifestyle and space. '
                          'Whether you love minimal designs or bold accents, Decora helps you '
                          'find what truly matches your vibe.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF7B7A7A),
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 135,
              left: -30,
              child: FadeTransition(
                opacity: _rectangleFade,
                child: Image.asset(Assets.rectangle1, height: 300),
              ),
            ),

            Positioned(
              top: 380,
              left: 60,
              child: FadeTransition(
                opacity: _rectangleFade,
                child: Image.asset(Assets.rectangle2, height: 300),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 185.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SlideTransition(
                      position: _line1Slide2,
                      child: const Center(
                        child: Text(
                          'Wood',
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.mainText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: SlideTransition(
                        position: _line2Slide2,
                        child: Image.asset(Assets.woodImg, fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 400, left: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SlideTransition(
                      position: _line1Slide,
                      child: const Text(
                        'Fabtics',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.mainText,
                        ),
                      ),
                    ),
                    //const SizedBox(height: 8),
                    SizedBox(
                      width: 50,
                      child: SlideTransition(
                        position: _line2Slide,
                        child: Image.asset(Assets.fabric, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SlideTransition(
                      position: _line3Slide,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '56% Cotton',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mainText,
                            ),
                          ),
                          Text(
                            '35% Wood',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mainText,
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
