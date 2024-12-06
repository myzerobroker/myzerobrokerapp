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
      'mobile_no': state.phoneNo.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://myzerobroker.com/api/login'), // Ensure this is the correct URL
        body: data,
      );

      // Check content type before decoding
      if (response.headers['content-type']?.contains('html') ?? false) {
        // If the response is HTML (could be a login page or error page)
        emit(state.copyWith(
          loginStatus: LoginStatus.error,
          message: 'Received HTML response, check the login URL or server config.',
        ));
      } else if (response.headers['content-type']?.contains('json') ?? false) {
        // Parse the JSON response
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
      } else {
        // Handle unexpected content types (e.g., plain text)
        emit(state.copyWith(
          loginStatus: LoginStatus.error,
          message: 'Unexpected response type: ${response.headers['content-type']}',
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
        Uri.parse('https://myzerobroker.com/api/verifyOtp'), // Ensure this is the correct URL
        body: data,
      );

      // Check content type before decoding
      if (response.headers['content-type']?.contains('html') ?? false) {
        // If the response is HTML
        emit(state.copyWith(
          loginStatus: LoginStatus.otpVerificationFailure,
          message: 'Received HTML response, check the verification URL or server config.',
        ));
      } else if (response.headers['content-type']?.contains('json') ?? false) {
        // Parse the JSON response
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
      } else {
        // Handle unexpected content types
        emit(state.copyWith(
          loginStatus: LoginStatus.otpVerificationFailure,
          message: 'Unexpected response type: ${response.headers['content-type']}',
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
