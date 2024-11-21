import 'package:flutter/material.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/presentation/presentaion.dart';
import 'package:my_zero_broker/presentation/screens/splash/splash_screen.dart';

class Routes {
 static Route<dynamic> generateRoute(RouteSettings settings){
  switch(settings.name){
    case RoutesName.splashScreen:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen()
        );

    case RoutesName.signUpScreen:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen()
        );        

    default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),));
  }
 }
}