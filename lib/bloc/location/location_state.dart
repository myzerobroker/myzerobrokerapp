abstract class LocationState {}

class LocationInitialState extends LocationState {}

class LocationLoadingState extends LocationState {}

class LocationLoadedState extends LocationState {
  final List<String> locations;
  LocationLoadedState(this.locations);
}

class LocationErrorState extends LocationState {
  final String message;
  LocationErrorState(this.message);
}
