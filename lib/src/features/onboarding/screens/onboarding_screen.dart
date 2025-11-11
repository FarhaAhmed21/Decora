import 'package:decora/src/features/Auth/screens/login_screen.dart';
import 'package:decora/src/features/onboarding/screens/onboarding_screen_one.dart';
import 'package:decora/src/features/onboarding/screens/onboarding_screen_three.dart';
import 'package:decora/src/features/onboarding/screens/onboarding_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  late AnimationController _lampController;
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _subtitleController;
  late AnimationController _treeController;

  late Animation<Offset> _lampAnimation;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<Offset> _subtitleAnimation;
  late Animation<Offset> _treeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playAnimations());
  }

  void _initAnimations() {
    const duration = Duration(milliseconds: 1650);

    _lampController = AnimationController(vsync: this, duration: duration);
    _imageController = AnimationController(vsync: this, duration: duration);
    _textController = AnimationController(vsync: this, duration: duration);
    _subtitleController = AnimationController(vsync: this, duration: duration);
    _treeController = AnimationController(vsync: this, duration: duration);

    _lampAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _lampController, curve: Curves.easeOut));

    _imageAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _textAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _subtitleAnimation =
        Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _subtitleController, curve: Curves.easeOut),
        );

    _treeAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _treeController, curve: Curves.easeOut));
  }

  void _playAnimations() async {
    _treeController.forward();
    _imageController.forward();
    _textController.forward();
    _subtitleController.forward();
    _lampController.forward();
  }

  void _resetAnimations() {
    _lampController.reset();
    _imageController.reset();
    _textController.reset();
    _subtitleController.reset();
    _treeController.reset();
    _playAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _lampController.dispose();
    _imageController.dispose();
    _textController.dispose();
    _subtitleController.dispose();
    _treeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _prevPage() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      OnboardingPageOne(
        lampAnimation: _lampAnimation,
        imageAnimation: _imageAnimation,
        textAnimation: _textAnimation,
        subtitleAnimation: _subtitleAnimation,
        treeAnimation: _treeAnimation,
        textController: _textController,
        subtitleController: _subtitleController,
      ),
      const OnboardingPageTwo(),
      const OnboardingPageThree(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                  _resetAnimations();
                },
                itemBuilder: (_, index) => pages[index],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 24 : 8,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.primary(context)
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _prevPage,
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: currentIndex == 0
                        ? Colors.grey.shade400
                        : AppColors.primary(context),
                  ),
                  InkWell(
                    onTap: _nextPage,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: currentIndex == 2
                          ? const Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
