part of 'fetch_user_details_bloc.dart';

sealed class FetchUserDetailsState extends Equatable {
  const FetchUserDetailsState();
  
  @override
  List<Object> get props => [];
}

final class FetchUserDetailsInitial extends FetchUserDetailsState {}
final class FetchUserDetailsLoading extends FetchUserDetailsState {}
final class FetchUserDetailsLoaded extends FetchUserDetailsState{
  final UserDetails userDetails;
  FetchUserDetailsLoaded(this.userDetails);
}
final class FetchUserDetailsError extends FetchUserDetailsState{
  final String message;
  FetchUserDetailsError(this.message);
}