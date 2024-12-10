import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'post_property_details_event.dart';
part 'post_property_details_state.dart';

class PostPropertyDetailsBloc
    extends Bloc<PostPropertyDetailsEvent, PostPropertyDetailsState> {
  PostPropertyDetailsBloc() : super(PostPropertyDetailsInitial()) {
    on<PostPropertyEventToApi>((event, emit) async {
      final data = event.propertyDetails;
      print(data);
      final url = "https://myzerobroker.com/api/post-property";
      emit(PostPropertyDetailsLoading());
      final body = jsonEncode(data);
      // print(body.runtimeType);
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 201) {
        emit(PostPropertyDetailsSuccessState(
            successMessage: jsonDecode(response.body)["message"]));
      } else {
        emit(PostPropertyDetailsFailureState(
            failureMessage: jsonDecode(response.body)["message"]));
      }
    });
  }
}
