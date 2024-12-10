abstract class AreaState {}

class AreaInitialState extends AreaState {}

class AreaLoadingState extends AreaState {}

class AreaLoadedState extends AreaState {
  final List<String> areas;
  AreaLoadedState(this.areas);
}

class AreaErrorState extends AreaState {
  final String message;
  AreaErrorState(this.message);
}
