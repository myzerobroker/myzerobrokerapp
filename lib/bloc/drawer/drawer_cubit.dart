import 'package:flutter_bloc/flutter_bloc.dart';

enum DrawerEvent { home, postProperty, settings, contacts }

class DrawerCubit extends Cubit<DrawerEvent> {
  DrawerCubit() : super(DrawerEvent.home);

  void showHome() => emit(DrawerEvent.home);
  void showPostProperty() => emit(DrawerEvent.postProperty);
  void showSettings() => emit(DrawerEvent.settings);
  void showContacts() => emit(DrawerEvent.contacts);
}
