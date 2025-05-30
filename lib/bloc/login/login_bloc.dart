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
    on<VerifyOtpApi>(_onVerifyOtpApi);
    on<EmailPasswordChanged>(_onEmailPasswordChanged);
    on<EmailLoginApi>(_onEmailLoginApi);
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

    print(state.phoneNo);

    Map data = {
      'mobile_no': "+91" + state.phoneNo.toString(),
    };

    try {
      print(data);
      final response = await http.post(
        Uri.parse('https://myzerobroker.com/api/login'),
        body: data,
      );

      if (response.headers['content-type']?.contains('json') ?? false) {
        var responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          print(responseData);
          emit(state.copyWith(
            loginStatus: LoginStatus.success,
            message: 'OTP sent successfully. Please enter it.',
            userId: int.tryParse(responseData['user_id'].toString()) ?? 0,
          ));
        } else {
          print(responseData);
          emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: responseData['message'] ?? 'Failed to send OTP',
          ));
        }
      } else {
        emit(state.copyWith(
          loginStatus: LoginStatus.error,
          message:
              'Unexpected response type: ${response.headers['content-type']}',
        ));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        message: e.toString(),
      ));
    }
  }

  void _onVerifyOtpApi(VerifyOtpApi event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    Map<String, String> data = {
      'otp': state.otp,
      'userId': locator.get<UserId>().id.toString(),
    };
    print(data);

    try {
      HttpOverrides.global = MyHttpOverrides();

      final getResponse =
          await http.get(Uri.parse('https://myzerobroker.com/login'));

      print('GET request status: ${getResponse.statusCode}');

      if (getResponse.statusCode == 200) {
        final csrfToken = extractCsrfToken(getResponse.body);
        print(csrfToken);

        if (csrfToken.isEmpty) {
          emit(state.copyWith(
            loginStatus: LoginStatus.otpVerificationFailure,
            message: 'CSRF token not found.',
          ));
          return;
        }

        final cookies = getResponse.headers['set-cookie'];
        print(cookies);
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

  void _onEmailPasswordChanged(
      EmailPasswordChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        password: event.password,
      ),
    );
  }

  void _onEmailLoginApi(EmailLoginApi event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    Map<String, String> data = {
      'email': state.email,
      'password': state.password,
    };

    try {
      HttpOverrides.global = MyHttpOverrides();

      final getResponse =
          await http.get(Uri.parse('https://myzerobroker.com/login-password'));

      print('GET request status: ${getResponse.statusCode}');

      if (getResponse.statusCode == 200) {
        final csrfToken = extractCsrfToken(getResponse.body);
        print('CSRF Token: $csrfToken');

        if (csrfToken.isEmpty) {
          emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: 'CSRF token not found.',
          ));
          return;
        }

        final cookies = getResponse.headers['set-cookie'];
        print('Cookies: $cookies');

        final response = await http.post(
          Uri.parse('https://myzerobroker.com/api/email-login'),
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

        if (response.headers['content-type']?.contains('json') ?? false) {
          var responseData = jsonDecode(response.body);

          if (response.statusCode == 200) {
            print(responseData);
            emit(state.copyWith(
              loginStatus: LoginStatus.success,
              message: 'Login successful.',
              userId: int.tryParse(responseData['user_id'].toString()) ?? 0,
            ));
          } else {
            emit(state.copyWith(
              loginStatus: LoginStatus.error,
              message: responseData['message'] ?? 'Login failed.',
            ));
          }
        } else {
          emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message:
                'Unexpected response type: ${response.headers['content-type']}',
          ));
        }
      } else {
        emit(state.copyWith(
          loginStatus: LoginStatus.error,
          message: 'Failed to fetch CSRF token.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        message: e.toString(),
      ));
    }
  }

  String extractCsrfToken(String html) {
    final csrfRegex = RegExp(r'<meta name="csrf-token" content="(.*?)">');
    final match = csrfRegex.firstMatch(html);
    return match?.group(1) ?? '';
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
