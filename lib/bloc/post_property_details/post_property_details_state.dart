part of 'post_property_details_bloc.dart';

sealed class PostPropertyDetailsState extends Equatable {
  const PostPropertyDetailsState();
  
  @override
  List<Object> get props => [];
}

final class PostPropertyDetailsInitial extends PostPropertyDetailsState {}
final class PostPropertyDetailsLoading extends PostPropertyDetailsState{}
final class PostPropertyDetailsSuccessState extends PostPropertyDetailsState{
  
}
final class PostPropertyDetailsFailureState extends PostPropertyDetailsState{
  final String failureMessage;
  PostPropertyDetailsFailureState({required this.failureMessage}); 
}
