import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitialState());

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is FetchLocationsEvent) {
      yield LocationLoadingState();
      try {
        final response = await http.get(Uri.parse('https://myzerobroker.com/api/city-details'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final locations = data.map((city) => city['c_name'] as String).toList();
          yield LocationLoadedState(locations);
        } else {
          yield LocationErrorState('Failed to load locations');
        }
      } catch (e) {
        yield LocationErrorState(e.toString());
      }
    }
  }
}
