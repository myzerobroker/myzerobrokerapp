part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error, otpVerificationSuccess, otpVerificationFailure }

class LoginState extends Equatable {
  const LoginState({
    this.phoneNo = '',
    this.otp = '',
    this.loginStatus = LoginStatus.initial,
    this.message = '',
  });

  final String phoneNo;
  final String otp;
  final LoginStatus loginStatus;
  final String message;

  LoginState copyWith({
    String? phoneNo,
    String? otp,
    LoginStatus? loginStatus,
    String? message,
  }) {
    return LoginState(
      phoneNo: phoneNo ?? this.phoneNo,
      otp: otp ?? this.otp,
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [phoneNo, otp, loginStatus, message];
}
