import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<phoneNoChanged>(_onPhoneNoChanged);
    on<otpChanged>(_onOtpChanged);
    on<LoginApi>(_onLoginApi);
    on<VerifyOtpApi>(_onVerifyOtpApi);  // New event to handle OTP verification
  }

  void _onPhoneNoChanged(phoneNoChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        phoneNo: event.phoneNo,
      ),
    );
  }

  void _onOtpChanged(otpChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        otp: event.otp,
      ),
    );
  }

  void _onLoginApi(LoginApi event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    Map data = {
      'phone': state.phoneNo.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://myzerobroker.com/login'), // Change to your backend URL
        body: data,
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(state.copyWith(
          loginStatus: LoginStatus.success,
          message: 'OTP sent successfully. Please enter it.',
        ));
      } else {
        emit(state.copyWith(
          loginStatus: LoginStatus.error,
          message: responseData['message'] ?? 'Failed to send OTP',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        message: e.toString(),
      ));
    }
  }
void _onVerifyOtpApi(VerifyOtpApi event, Emitter<LoginState> emit) async {
  emit(state.copyWith(loginStatus: LoginStatus.loading));

   Map data = {
    'phone': state.phoneNo.toString(),
    'otp': state.otp.toString(),
  };

  try {
    final response = await http.post(
      Uri.parse('https://myzerobroker.com/verifyOtp'), // Change to your backend URL
      body: data,
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      emit(state.copyWith(
        loginStatus: LoginStatus.otpVerificationSuccess, // Use the new status
        message: 'OTP verified successfully.',
      ));
    } else {
      emit(state.copyWith(
        loginStatus: LoginStatus.otpVerificationFailure, // Use the new status
        message: responseData['message'] ?? 'OTP verification failed',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      loginStatus: LoginStatus.otpVerificationFailure, // Use the new status
      message: e.toString(),
    ));
  }
}

}
