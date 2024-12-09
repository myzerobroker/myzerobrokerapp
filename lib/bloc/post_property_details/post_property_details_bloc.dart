import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_property_details_event.dart';
part 'post_property_details_state.dart';

class PostPropertyDetailsBloc extends Bloc<PostPropertyDetailsEvent, PostPropertyDetailsState> {
  PostPropertyDetailsBloc() : super(PostPropertyDetailsInitial()) {
    on<PostPropertyDetailsEvent>((event, emit) {
     
    });
  }
}
