import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'area_event.dart';
import 'area_state.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  AreaBloc() : super(AreaInitialState());

  @override
  Stream<AreaState> mapEventToState(AreaEvent event) async* {
    if (event is FetchAreasEvent) {
      yield AreaLoadingState();
      try {
        final response = await http.get(Uri.parse('https://myzerobroker.com/api/areas?cityId=${event.cityId}'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final areas = data.map((area) => area['a_name'] as String).toList();
          yield AreaLoadedState(areas);
        } else {
          yield AreaErrorState('Failed to load areas');
        }
      } catch (e) {
        yield AreaErrorState(e.toString());
      }
    }
  }
}
