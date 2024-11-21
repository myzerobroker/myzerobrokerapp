import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void checkAuthentication() {

    Future.delayed(const Duration(seconds: 3), () {
     
      bool isAuthenticated = true; 

      emit(SplashLoaded(isUserAuthenticated: isAuthenticated));
    });
  }
}
