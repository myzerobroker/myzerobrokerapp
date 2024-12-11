import 'package:equatable/equatable.dart';

enum ContactStatus { initial, sending, success, failure }

class ContactState extends Equatable {
  final ContactStatus status;
  final String? message;

  const ContactState({
    this.status = ContactStatus.initial,
    this.message,
  });

  ContactState copyWith({
    ContactStatus? status,
    String? message,
  }) {
    return ContactState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
