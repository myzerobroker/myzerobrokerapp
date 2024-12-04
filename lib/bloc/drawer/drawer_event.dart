import 'package:equatable/equatable.dart';

/// Events to handle navigation.
abstract class DrawerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NavigateToHome extends DrawerEvent {}

class NavigateToPostProperty extends DrawerEvent {}

class NavigateToPlans extends DrawerEvent {}

class NavigateToLogin extends DrawerEvent {}

class NavigateToNewUser extends DrawerEvent {}

class NavigateToContacts extends DrawerEvent {}
