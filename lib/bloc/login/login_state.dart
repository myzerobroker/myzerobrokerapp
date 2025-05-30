part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error, otpVerificationSuccess, otpVerificationFailure }

class LoginState extends Equatable {
  final String phoneNo;
  final String otp;
  final int userId;
  final String email;
  final String password;
  final LoginStatus loginStatus;
  final String message;

  const LoginState({
    this.phoneNo = '',
    this.otp = '',
    this.userId = 0,
    this.email = '',
    this.password = '',
    this.loginStatus = LoginStatus.initial,
    this.message = '',
  });

  LoginState copyWith({
    String? phoneNo,
    String? otp,
    int? userId,
    String? email,
    String? password,
    LoginStatus? loginStatus,
    String? message,
  }) {
    return LoginState(
      phoneNo: phoneNo ?? this.phoneNo,
      otp: otp ?? this.otp,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      password: password ?? this.password,
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [phoneNo, otp, userId, email, password, loginStatus, message];
}