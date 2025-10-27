import 'package:decora/src/features/onboarding/screens/onboarding_screen.dart';
import 'package:decora/src/features/splash/cubit/splash_cubit.dart';
import 'package:decora/src/features/splash/cubit/splash_sate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<SplashCubit>().animationCompleted();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset(
            'assets/animations/splash-animation.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.forward();
            },
          ),
        ),
      ),
    );
  }
}
