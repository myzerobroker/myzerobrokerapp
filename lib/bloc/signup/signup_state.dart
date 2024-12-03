

import 'package:equatable/equatable.dart';

enum SignUpStatus { initial, loading, success, error }

class SignUpState extends Equatable {
  const SignUpState({
    this.phoneNo = '',
    this.fullName = '',
    this.email = '',
    this.signupStatus = SignUpStatus.initial,
    this.message = '',
  });

  final String phoneNo;
  final String fullName;
  final String email;
  final SignUpStatus signupStatus;
  final String message;

  SignUpState copyWith({
    String? phoneNo,
    String? fullname,
    String? email,
    SignUpStatus? signupStatus,
    String? message,
  }) {
    return SignUpState(
      phoneNo: phoneNo ?? this.phoneNo,
      fullName: fullname ?? this.fullName,
      email: email ?? this.email,
      signupStatus: signupStatus ?? this.signupStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [phoneNo, fullName,email ,signupStatus, message];
}
