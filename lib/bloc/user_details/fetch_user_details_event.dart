part of 'fetch_user_details_bloc.dart';

sealed class FetchUserDetailsEvent extends Equatable {
  const FetchUserDetailsEvent();

  @override
  List<Object> get props => [];
}
class FetchDetailsEvent extends FetchUserDetailsEvent{
  
}