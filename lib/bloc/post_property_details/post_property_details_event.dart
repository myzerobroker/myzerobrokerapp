part of 'post_property_details_bloc.dart';

sealed class PostPropertyDetailsEvent extends Equatable {
  const PostPropertyDetailsEvent();

  @override
  List<Object> get props => [];
}

class PostPropertyEventToApi extends PostPropertyDetailsEvent{
  final Map<String, dynamic> propertyDetails;
  PostPropertyEventToApi({required this.propertyDetails});
  @override
  List<Object> get props => [propertyDetails];
}