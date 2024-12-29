part of 'my_listing_bloc.dart';

sealed class MyListingState extends Equatable {
  const MyListingState();
  
  @override
  List<Object> get props => [];
}

final class MyListingInitial extends MyListingState {}
class MyListingLoading extends MyListingState {}
class MyListingLoaded extends MyListingState {
  final List<Property> myListing;
  
  const MyListingLoaded(this.myListing);
  
  @override
  List<Object> get props => [myListing];
}
class MyListingError extends MyListingState {
  final String message;
  
  const MyListingError(this.message);
  
  @override
  List<Object> get props => [message];
}