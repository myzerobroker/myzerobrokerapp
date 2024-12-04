import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_event.dart';
import 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(HomeState()) {
    on<NavigateToHome>((event, emit) => emit(HomeState()));
    on<NavigateToPostProperty>((event, emit) => emit(PostPropertyState()));
    on<NavigateToPlans>((event, emit) => emit(PlansState()));
    on<NavigateToLogin>((event, emit) => emit(LoginState()));
    on<NavigateToNewUser>((event, emit) => emit(NewUserState()));
    on<NavigateToContacts>((event, emit) => emit(ContactsState()));
  }
}
