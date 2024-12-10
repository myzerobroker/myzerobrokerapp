import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/Enquiry/enquiry_event.dart';
import 'package:my_zero_broker/bloc/Enquiry/enquiry_state.dart';


class EnquiryBloc extends Bloc<EnquiryEvent, EnquiryState> {
  EnquiryBloc() : super(const EnquiryState()) {
    on<NameChanged>((event, emit) => emit(state.copyWith(name: event.name)));
    on<EmailChanged>((event, emit) => emit(state.copyWith(email: event.email)));
    on<SubjectChanged>((event, emit) => emit(state.copyWith(subject: event.subject)));
    on<QueryChanged>((event, emit) => emit(state.copyWith(query: event.query)));
    on<PhoneNumberChanged>((event, emit) => emit(state.copyWith(phoneNumber: event.phoneNumber)));
    on<SubmitEnquiry>(_onSubmitEnquiry);
  }

  Future<void> _onSubmitEnquiry(SubmitEnquiry event, Emitter<EnquiryState> emit) async {
    emit(state.copyWith(status: EnquiryStatus.loading));

    final data = {
      'name': state.name,
      'email': state.email,
      'subject': state.subject,
      'query': state.query,
      'mobile_no': state.phoneNumber,
    };

    try {
    
      final response = await http.post(
        Uri.parse('https://myzerobroker.com/api/submit-enquiry'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        emit(state.copyWith(
          status: EnquiryStatus.success,
          message: responseData['message'] ?? 'Enquiry submitted successfully.',
        ));
      } else {
        final responseData = jsonDecode(response.body);
        emit(state.copyWith(
          status: EnquiryStatus.error,
          message: responseData['message'] ?? 'Failed to submit enquiry.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: EnquiryStatus.error,
        message: 'Error occurred: $e',
      ));
    }
  }
}
