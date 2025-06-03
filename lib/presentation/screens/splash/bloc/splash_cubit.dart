import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  checkAuthentication() async {
    Future.delayed(const Duration(seconds: 1), () async {
      bool isAuthenticated = true;
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('authToken');
      print("Token: $token");

      

      emit(SplashLoaded(isUserAuthenticated: isAuthenticated));
    });
  }
}
