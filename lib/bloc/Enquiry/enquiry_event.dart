import 'package:equatable/equatable.dart';

abstract class EnquiryEvent extends Equatable {
  const EnquiryEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends EnquiryEvent {
  const NameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class EmailChanged extends EnquiryEvent {
  const EmailChanged(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

class SubjectChanged extends EnquiryEvent {
  const SubjectChanged(this.subject);
  final String subject;

  @override
  List<Object> get props => [subject];
}

class QueryChanged extends EnquiryEvent {
  const QueryChanged(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}

class PhoneNumberChanged extends EnquiryEvent {
  const PhoneNumberChanged(this.phoneNumber);
  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class SubmitEnquiry extends EnquiryEvent {}
