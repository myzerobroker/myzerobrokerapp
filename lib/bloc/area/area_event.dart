abstract class AreaEvent {}

class FetchAreasEvent extends AreaEvent {
  final String cityId;
  FetchAreasEvent(this.cityId);
}
