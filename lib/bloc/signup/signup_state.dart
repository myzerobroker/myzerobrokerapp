import 'package:equatable/equatable.dart';

enum SignUpStatus { initial, loading, success, error }
enum UpdateStatus { initial, loading, success, error }

class SignUpState extends Equatable {
  const SignUpState({
    this.phoneNo = '',
    this.fullName = '',
    this.email = '',
    this.signupStatus = SignUpStatus.initial,
    this.updateStatus = UpdateStatus.initial,
    this.message = '',
  });

  final String phoneNo;
  final String fullName;
  final String email;
  final SignUpStatus signupStatus;
  final UpdateStatus updateStatus;
  final String message;

  SignUpState copyWith({
    String? phoneNo,
    String? fullName,
    String? email,
    SignUpStatus? signupStatus,
    UpdateStatus? updateStatus,
    String? message,
  }) {
    return SignUpState(
      phoneNo: phoneNo ?? this.phoneNo,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      signupStatus: signupStatus ?? this.signupStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        phoneNo,
        fullName,
        email,
        signupStatus,
        updateStatus,
        message,
      ];
}
