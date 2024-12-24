import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_event.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_state.dart';


class PostFormladBloc
    extends Bloc<PostFormladEvent, PostFormladState> {
  PostFormladBloc() : super(PostFormladInitial()) {
    on<PostPropertyEventToApi>((event, emit) async {
      final data = event.propertyDetails;
      print(data);
      final url = "https://myzerobroker.com/api/post-property";
      emit(PostFormladsLoading());
      final body = jsonEncode(data);
      // print(body.runtimeType);
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 201) {
        emit(PostFormladSuccessState(
            successMessage: jsonDecode(response.body)["message"]));
      } else {
        emit(PostFormladFailureState(
            failureMessage: jsonDecode(response.body)["message"]));
      }
    });
  }
}
