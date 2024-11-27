import 'package:flutter_bloc/flutter_bloc.dart';

enum DrawerEvent { home, postProperty, plans, login, newUser, contacts }

class DrawerCubit extends Cubit<DrawerEvent> {
  DrawerCubit() : super(DrawerEvent.home);

  void navigate(DrawerEvent event) => emit(event);
}
