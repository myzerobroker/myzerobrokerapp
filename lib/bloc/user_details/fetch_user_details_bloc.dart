import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_zero_broker/data/models/user_details_model.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';

part 'fetch_user_details_event.dart';
part 'fetch_user_details_state.dart';

class FetchUserDetailsBloc
    extends Bloc<FetchUserDetailsEvent, FetchUserDetailsState> {
  FetchUserDetailsBloc() : super(FetchUserDetailsInitial()) {
    on<FetchDetailsEvent>((event, emit) async {
      emit(FetchUserDetailsLoading());
      final user =
          await locator.get<UserDetailsDependency>().fetchUserDetails();
      print(user!.toJson());
      if (user != null) {
        emit(FetchUserDetailsLoaded(user));
      } else {
        emit(FetchUserDetailsError("Error Fetching User Details"));
      }
    });
  }
}
