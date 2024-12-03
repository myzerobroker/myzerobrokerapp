



import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class phoneNoChanged extends SignupEvent {
  const phoneNoChanged({required this.phoneNo});

  final String phoneNo;

  @override
  List<Object> get props => [phoneNo];
}

class fullNameChanged extends SignupEvent {
  const fullNameChanged({required this.fullName});

  final String fullName;

  @override
  List<Object> get props => [fullName];
}

class EmailChanged extends SignupEvent {
  const  EmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}
class SignUpApi extends SignupEvent {}


