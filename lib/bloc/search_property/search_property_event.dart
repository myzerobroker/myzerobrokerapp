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
  final String status;
  final String property_type;
  final String priceRange; 
  final String bhk;
  final String tp; 

  SearchBuyProperty(
      {required this.city_id,
      required this.area_id,
      required this.page,
      required this.status,
      required this.property_type,
      required this.priceRange,
      required this.tp,
      required this.bhk});
}
