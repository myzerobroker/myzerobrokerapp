import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/home_screen.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_cubit.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_state.dart';
import 'package:page_transition/page_transition.dart';

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
                    child:  HomeScreen(),
                  ),
                );
              } else {
            
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: HomeScreen(),
                  ),
                );
              }
            }
          },
          builder: (context, state) {

            if (state is SplashInitial) {
              return AnimatedSplashScreen(
                duration: 3000, 
                splash: 'assets/images/my_zero_broker_logo (2).png',
                nextScreen: const SizedBox.shrink(), 
                splashTransition: SplashTransition.fadeTransition,
                pageTransitionType: PageTransitionType.leftToRight,
                backgroundColor: Colors.white,
              );
            }
            return const SizedBox.shrink(); 
          },
        ),
      ),
    );
  }
}
