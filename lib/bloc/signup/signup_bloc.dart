import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/signup/signup_event.dart';
import 'package:my_zero_broker/bloc/signup/signup_state.dart';


class SignupBloc extends Bloc<SignupEvent, SignUpState> {
  SignupBloc() : super(const SignUpState()) {
    on<phoneNoChanged>(_onPhoneNoChanged);
    on<fullNameChanged>(_onfullNameChanged);
    on<EmailChanged>(_onemailChanged);
    on<SignUpApi>(_onSignUpApi);

  }

  void _onPhoneNoChanged(phoneNoChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        phoneNo: event.phoneNo,
      ),
    );
  }

   void _onemailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: event.email,
      ),
    );
  }

  void _onfullNameChanged(fullNameChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        fullname: event.fullName,
      ),
    );
  }

  void _onSignUpApi(SignUpApi event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(signupStatus: SignUpStatus.loading));

    Map data = {
      'phone': state.phoneNo.toString(),
      'fullname': state.fullName.toString(),
      'email': state.email.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://myzerobroker.com//register'), // Change to your backend URL
        body: data,
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(state.copyWith(
          signupStatus: SignUpStatus.success,
          message: 'Registered successfully.',
        ));
      } else {
        emit(state.copyWith(
          signupStatus: SignUpStatus.error,
          message: responseData['message'] ?? 'Failed to send OTP',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        signupStatus: SignUpStatus.error,
        message: e.toString(),
      ));
    }
  }


}
