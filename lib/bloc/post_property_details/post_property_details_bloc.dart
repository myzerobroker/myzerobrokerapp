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
      final url = "https://myzerobroker.com/api/post-property";

      // Emitting loading state
      emit(PostPropertyDetailsLoading());

      try {
        // Create a multipart request
        final request = http.MultipartRequest('POST', Uri.parse(url));

        // Add other fields as form fields
        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        print(data);
        // Send the request
        final response = await request.send();

        // Handle the response
        final responseBody = await response.stream.bytesToString();
        print(responseBody);
        if (response.statusCode == 201) {
          emit(PostPropertyDetailsSuccessState(
              successMessage: jsonDecode(responseBody)["message"]));
        } else {
          emit(PostPropertyDetailsFailureState(
              failureMessage: jsonDecode(responseBody)["message"]));
        }
      } catch (error) {
        // Handle errors
        emit(PostPropertyDetailsFailureState(
            failureMessage: "An error occurred: $error"));
      }
    });
  }
}
