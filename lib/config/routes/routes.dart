import 'package:flutter/material.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/presentation/presentaion.dart';
import 'package:my_zero_broker/presentation/screens/login/otp_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return _createRoute(const SplashScreen());

      case RoutesName.loginScreen:
        return _createRoute(const LoginScreen());

      case RoutesName.otpScreen:  // New route for OTP screen
        return _createRoute(const OtpScreen());

      case RoutesName.signUpScreen:
        return _createRoute(SignupScreen());

      default:
        return _createRoute(const Scaffold(
          body: Center(child: Text('No route defined')),
        ));
    }
  }

  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
