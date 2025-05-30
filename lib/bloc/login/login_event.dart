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
// class EmailLoginApi extends LoginEvent {}

class VerifyOtpApi extends LoginEvent {
  final int userID;

  const VerifyOtpApi(this.userID);

  @override
  List<Object> get props => [userID];
}

class EmailPasswordChanged extends LoginEvent {
  final String email;
  final String password;

  const EmailPasswordChanged({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class EmailLoginApi extends LoginEvent {}