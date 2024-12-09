import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/property_details.dart/property_details_event.dart';
import 'package:my_zero_broker/bloc/property_details.dart/property_details_state.dart';


class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(const PropertyState()) {
    on<TitleChanged>(_onTitleChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<PriceChanged>(_onPriceChanged);
    on<PhotosChanged>(_onPhotosChanged);
    on<SubmitProperty>(_onSubmitProperty);
  }

  void _onTitleChanged(TitleChanged event, Emitter<PropertyState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(DescriptionChanged event, Emitter<PropertyState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onPriceChanged(PriceChanged event, Emitter<PropertyState> emit) {
    emit(state.copyWith(price: event.price));
  }

  void _onPhotosChanged(PhotosChanged event, Emitter<PropertyState> emit) {
    emit(state.copyWith(photos: event.photos));
  }

  Future<void> _onSubmitProperty(
      SubmitProperty event, Emitter<PropertyState> emit) async {
    emit(state.copyWith(status: PropertyFormStatus.loading));

    try {
      final uri = Uri.parse("https://example.com/api/properties");
      final request = http.MultipartRequest('POST', uri);

      // Add form fields
      request.fields['title'] = state.title;
      request.fields['description'] = state.description;
      request.fields['price'] = state.price.toString();

      // Attach photos
      for (File photo in state.photos) {
        request.files.add(await http.MultipartFile.fromPath(
          'photos',
          photo.path,
        ));
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        emit(state.copyWith(
          status: PropertyFormStatus.success,
          message: "Property submitted successfully.",
        ));
      } else {
        final responseData = jsonDecode(response.body);
        emit(state.copyWith(
          status: PropertyFormStatus.error,
          message: responseData['message'] ?? "Failed to submit property.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PropertyFormStatus.error,
        message: e.toString(),
      ));
    }
  }
}
