part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error, otpVerificationSuccess, otpVerificationFailure }
class LoginState extends Equatable {
  final String phoneNo;
  final String otp;
  final int userId; // userId remains an integer
  final LoginStatus loginStatus;
  final String message;

  const LoginState({
    this.phoneNo = '',
    this.otp = '',
    this.userId = 0, // Initialize as an integer
    this.loginStatus = LoginStatus.initial,
    this.message = '',
  });

  LoginState copyWith({
    String? phoneNo,
    String? otp,
    int? userId, // userId as integer
    LoginStatus? loginStatus,
    String? message,
  }) {
    return LoginState(
      phoneNo: phoneNo ?? this.phoneNo,
      otp: otp ?? this.otp,
      userId: userId ?? this.userId, // Ensure userId is passed as integer
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [phoneNo, otp, userId, loginStatus, message];
}
