import 'package:equatable/equatable.dart';

abstract class PropertyFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateFullName extends PropertyFormEvent {
  final String fullName;
  UpdateFullName(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class UpdateEmail extends PropertyFormEvent {
  final String email;
  UpdateEmail(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdatePhoneNumber extends PropertyFormEvent {
  final String phoneNumber;
  UpdatePhoneNumber(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class UpdateCity extends PropertyFormEvent {
  final String city;
  UpdateCity(this.city);

  @override
  List<Object?> get props => [city];
}

class UpdateIsResidential extends PropertyFormEvent {
  final bool isResidential;
  UpdateIsResidential(this.isResidential);

  @override
  List<Object?> get props => [isResidential];
}

class UpdateAdType extends PropertyFormEvent {
  final String adType;
  UpdateAdType(this.adType);

  @override
  List<Object?> get props => [adType];
}
