part of 'search_property_bloc.dart';

sealed class SearchPropertyEvent extends Equatable {
  const SearchPropertyEvent();

  @override
  List<Object> get props => [];
}

class SearchBuyProperty extends SearchPropertyEvent {
  final String city_id;
  final String area_id;
  final int page;

  SearchBuyProperty({required this.city_id, required this.area_id, required this.page });
}

