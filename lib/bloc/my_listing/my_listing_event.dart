part of 'my_listing_bloc.dart';

sealed class MyListingEvent extends Equatable {
  const MyListingEvent();

  @override
  List<Object> get props => [];
}
class FetchMyListing extends MyListingEvent {
  const FetchMyListing();
}