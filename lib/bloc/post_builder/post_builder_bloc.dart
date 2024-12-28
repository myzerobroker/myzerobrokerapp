import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/post_builder/post_builder_event.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_state.dart';


class PostBuildersDetailsBloc
    extends Bloc<PostBuildersDetailsEvent, PostBuildersDetailsState> {
  PostBuildersDetailsBloc() : super(PostBuilderDetailsInitial()) {
    on<PostBuilderEventToApi>((event, emit) async {
      final data = event.propertyDetails;
      print(data);
      final url = "https://myzerobroker.com/api/user/property/post-builder-property";
      emit(PostBuilderDetailsLoading());
      final body = jsonEncode(data);
      // print(body.runtimeType);
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 201) {
        emit(PostBuilderDetailsSuccessState(
            successMessage: jsonDecode(response.body)["message"]));
      } else {
        emit(PostBuilderDetailsFailureState(
            failureMessage: jsonDecode(response.body)["message"]));
      }
    });
  }
}
