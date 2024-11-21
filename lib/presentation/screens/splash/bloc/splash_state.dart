abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {
  final bool isUserAuthenticated;

  SplashLoaded({required this.isUserAuthenticated});
}
