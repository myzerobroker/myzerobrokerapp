import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/data/user_id.dart';
import 'package:my_zero_broker/locator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<phoneNoChanged>(_onPhoneNoChanged);
    on<otpChanged>(_onOtpChanged);
    on<LoginApi>(_onLoginApi);
    on<VerifyOtpApi>(_onVerifyOtpApi); // New event to handle OTP verification
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
        Uri.parse('https://myzerobroker.com/api/login'),
        body: data,
      );

      if (response.headers['content-type']?.contains('json') ?? false) {
        var responseData = jsonDecode(response.body);
        print(responseData);
        if (response.statusCode == 200) {
          emit(state.copyWith(
            loginStatus: LoginStatus.success,
            message: 'OTP sent successfully. Please enter it.',
            userId: int.tryParse(responseData['user_id'].toString()) ?? 0, // Parse user_id as integer
          ));
        } else {
          emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: responseData['message'] ?? 'Failed to send OTP',
          ));
        }
      } else {
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

    // Ensure OTP is sent as String and userId as Integer
    Map<String, String> data = {
      'otp': state.otp, // Send OTP as a string
      'userId': locator.get<UserId>().id.toString(), // Ensure userId is a string
    };

    try {
      // Ignore SSL errors (for development only)
      HttpOverrides.global = MyHttpOverrides();

      // First, make a GET request to retrieve the CSRF token and cookies
      final getResponse = await http.get(Uri.parse('https://myzerobroker.com/verifyOtp'));


      print('GET request status: ${getResponse.statusCode}');
      print('GET response body: ${getResponse.body}');

      if (getResponse.statusCode == 200) {
        final csrfToken = extractCsrfToken(getResponse.body);

        if (csrfToken.isEmpty) {
          emit(state.copyWith(
            loginStatus: LoginStatus.otpVerificationFailure,
            message: 'CSRF token not found.',
          ));
          return;
        }

        final cookies = getResponse.headers['set-cookie'];

        final response = await http.post(
          Uri.parse('https://myzerobroker.com/api/verifyOtp'),
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': csrfToken,
            'Accept': 'application/json',
            'Cookie': cookies ?? '',
          },
          body: jsonEncode(data),
        );

        print('POST request status: ${response.statusCode}');
        print('POST response body: ${response.body}');

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          emit(state.copyWith(
            loginStatus: LoginStatus.otpVerificationSuccess,
            message: 'OTP verified successfully.',
          ));
        } else {
          var responseData = jsonDecode(response.body);
          emit(state.copyWith(
            loginStatus: LoginStatus.otpVerificationFailure,
            message: responseData['message'] ?? 'OTP verification failed.',
          ));
        }
      } else {
        emit(state.copyWith(
          loginStatus: LoginStatus.otpVerificationFailure,
          message: 'Failed to fetch CSRF token.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.otpVerificationFailure,
        message: e.toString(),
      ));
    }
  }

  // Extract CSRF Token from HTML response
  String extractCsrfToken(String html) {
    final csrfRegex = RegExp(r'<meta name="csrf-token" content="(.*?)">');
    final match = csrfRegex.firstMatch(html);
    return match?.group(1) ?? '';
  }
}

// Custom HttpOverrides to ignore SSL certificate errors
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
