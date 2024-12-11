part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<CityDetails> cityDetails;

  LocationLoaded({required this.cityDetails});
}

final class LocationError extends LocationState {
  final String message;

  LocationError({required this.message}); 

}
