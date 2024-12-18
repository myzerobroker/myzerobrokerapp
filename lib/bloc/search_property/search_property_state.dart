part of 'search_property_bloc.dart';

sealed class SearchPropertyState extends Equatable {
  const SearchPropertyState();
  
  @override
  List<Object> get props => [];
}

final class SearchPropertyInitial extends SearchPropertyState {}
final class SearchPropertyLoading extends SearchPropertyState {}
final class SearchPropertyLoaded extends SearchPropertyState {
  final PropertyInCityModel properties;

  SearchPropertyLoaded({required this.properties});
}
final class SearchPropertyError extends SearchPropertyState {
  final String message;

  SearchPropertyError({required this.message});
}