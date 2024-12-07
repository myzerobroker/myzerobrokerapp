part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class phoneNoChanged extends LoginEvent {
  const phoneNoChanged({required this.phoneNo});

  final String phoneNo;

  @override
  List<Object> get props => [phoneNo];
}

class otpChanged extends LoginEvent {
  const otpChanged({required this.otp});

  final String otp;

  @override
  List<Object> get props => [otp];
}

class LoginApi extends LoginEvent {}

class VerifyOtpApi extends LoginEvent {
  final int  userID;

  VerifyOtpApi(this.userID); 
}  // New event for OTP verification
