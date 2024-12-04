import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/data/models/property_form_model.dart';

import 'property_form_event.dart';
import 'property_form_state.dart';

class PropertyFormBloc extends Bloc<PropertyFormEvent, PropertyFormState> {
  PropertyFormBloc()
      : super(
          PropertyFormState(
            form: PropertyFormModel(
              fullName: '',
              email: '',
              phoneNumber: '',
              city: 'Ahmednagar',
              isResidential: true,
              adType: 'Sale/Resale',
            ),
          ),
        ) {
    on<UpdateFullName>((event, emit) {
      emit(state.copyWith(
          form: state.form.copyWith(fullName: event.fullName)));
    });

    on<UpdateEmail>((event, emit) {
      emit(state.copyWith(form: state.form.copyWith(email: event.email)));
    });

    on<UpdatePhoneNumber>((event, emit) {
      emit(state.copyWith(
          form: state.form.copyWith(phoneNumber: event.phoneNumber)));
    });

    on<UpdateCity>((event, emit) {
      emit(state.copyWith(form: state.form.copyWith(city: event.city)));
    });

    on<UpdateIsResidential>((event, emit) {
      emit(state.copyWith(
          form: state.form.copyWith(isResidential: event.isResidential)));
    });

    on<UpdateAdType>((event, emit) {
      emit(state.copyWith(form: state.form.copyWith(adType: event.adType)));
    });
  }
}
