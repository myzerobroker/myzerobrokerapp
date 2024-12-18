import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:http/http.dart' as http;
part 'search_property_event.dart';
part 'search_property_state.dart';

class SearchPropertyBloc
    extends Bloc<SearchPropertyEvent, SearchPropertyState> {
  SearchPropertyBloc() : super(SearchPropertyInitial()) {
    on<SearchBuyProperty>((event, emit) async {
      final city_id = event.city_id;
      final area_id = event.area_id;
      emit(SearchPropertyLoading());
      try {
        final res = await http.get(Uri.parse(
            'https://myzerobroker.com/api/search?city_id=$city_id&area_id=$area_id'));
        if (res.statusCode == 200) {
          final property = PropertyInCityModel.fromJson(jsonDecode(res.body));
          print(property.propertyCount);
          emit(SearchPropertyLoaded(properties: property));
        } else {
          emit(SearchPropertyError(message: 'Failed to load property'));
        }
      } catch (err) {
        print(err);
        emit(SearchPropertyError(message: "Failed to load property"));
      }
    });
  }
}
