import 'package:equatable/equatable.dart';

/// States to represent current navigation screen.
abstract class DrawerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeState extends DrawerState {}

class PostPropertyState extends DrawerState {}

class PlansState extends DrawerState {}

class LoginState extends DrawerState {}

class NewUserState extends DrawerState {}

class ContactsState extends DrawerState {}
