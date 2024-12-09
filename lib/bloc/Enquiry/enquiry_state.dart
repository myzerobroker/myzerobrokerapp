import 'package:equatable/equatable.dart';

enum EnquiryStatus { initial, loading, success, error }

class EnquiryState extends Equatable {
  const EnquiryState({
    this.name = '',
    this.email = '',
    this.subject = '',
    this.query = '',
    this.phoneNumber = '',
    this.status = EnquiryStatus.initial,
    this.message = '',
  });

  final String name;
  final String email;
  final String subject;
  final String query;
  final String phoneNumber;
  final EnquiryStatus status;
  final String message;

  EnquiryState copyWith({
    String? name,
    String? email,
    String? subject,
    String? query,
    String? phoneNumber,
    EnquiryStatus? status,
    String? message,
  }) {
    return EnquiryState(
      name: name ?? this.name,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      query: query ?? this.query,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [name, email, subject, query, phoneNumber, status, message];
}
