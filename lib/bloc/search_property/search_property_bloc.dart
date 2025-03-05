import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';

part 'search_property_event.dart';
part 'search_property_state.dart';

class SearchPropertyBloc
    extends Bloc<SearchPropertyEvent, SearchPropertyState> {
  SearchPropertyBloc() : super(SearchPropertyInitial()) {
    on<SearchBuyProperty>((event, emit) async {
      final city_id = event.city_id;
      final area_id = event.area_id;
      final page = event.page;
      final property_type = event.property_type;
      final status = event.status;

      String range = event.priceRange;
      final pricerange = {
        "₹10 Lakh - ₹20 Lakh": "1000000-2000000",
        "₹20 Lakh - ₹30 Lakh": "2000000-3000000",
        "₹30 Lakh - ₹50 Lakh": "3000000-5000000",
        "₹50 Lakh - ₹1 Cr": "5000000-10000000",
        "Above ₹1 Cr": "10000000%2B",
      };
      print(pricerange[range]);
      final r = range == "" ? "" : pricerange[range];
      emit(SearchPropertyLoading());
      final url =
          'https://myzerobroker.com/api/search?city_id=$city_id&locality_id=$area_id&page=$page&property_status=${event.tp}&bhk=${event.bhk}&price_range=${r}&property_select=$status';
      print(url);
      try {
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          final property = PropertyInCityModel.fromJson(jsonDecode(res.body));
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
