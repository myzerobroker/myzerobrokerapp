import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/presentation/screens/locations_fetch_widget.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_cubit.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_state.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController for zoom in/out effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Reasonable duration for smooth animation
    )..repeat(reverse: true); // Repeat animation, reversing direction each time

    // Define the scale animation (from 0.5 to 1.3 and back)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smooth easing for natural effect
      ),
    );

    // Trigger the authentication check
    context.read<SplashCubit>().checkAuthentication();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashLoaded) {
              if (state.isUserAuthenticated) {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: LocationsFetchWidget(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: LocationsFetchWidget(),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is SplashInitial) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/my_zero_broker_logo (2).png',
                      width: 200, // Adjust size as needed
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'REAL ESTATE, SIMPLIFIED',
                        cursor: " ",
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}