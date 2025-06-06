import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/home_screen.dart';
import 'package:my_zero_broker/presentation/screens/locations_fetch_widget.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_cubit.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_state.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the authentication check
    context.read<SplashCubit>().checkAuthentication();

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
                    type: PageTransitionType.fade,
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
                  Image.asset(
                    'assets/images/my_zero_broker_logo (2).png',
                    width: 200, // Adjust size as needed
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