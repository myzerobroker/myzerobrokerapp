import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:http/http.dart' as http;
part 'my_listing_event.dart';
part 'my_listing_state.dart';

class MyListingBloc extends Bloc<MyListingEvent, MyListingState> {
  MyListingBloc() : super(MyListingInitial()) {
    on<FetchMyListing>((event, emit) async {
      String url = "https://www.myzerobroker.com/api/user/my-listings?user_id=";
      int id = locator.get<UserDetailsDependency>().id;
      url += id.toString();
      try {
        emit(MyListingLoading());
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final list = json["data"] as List;
          final List<Property> proprties =
              list.map((e) => Property.fromJson(e)).toList();
          emit(MyListingLoaded(proprties));
        }
        else{
          emit(MyListingError("Error"));
        }
      } catch (err) {
        print(err);
        emit(MyListingError(err.toString()));
      }
    });
  }
}
