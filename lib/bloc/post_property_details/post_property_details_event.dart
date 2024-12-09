part of 'post_property_details_bloc.dart';

sealed class PostPropertyDetailsEvent extends Equatable {
  const PostPropertyDetailsEvent();

  @override
  List<Object> get props => [];
}

class PostPropertyEventToApi extends PostPropertyDetailsEvent{

}