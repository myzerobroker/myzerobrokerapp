import 'dart:convert';
import 'dart:io';

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
    emit(state.copyWith(phoneNo: event.phoneNo));
  }

  void _onemailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onfullNameChanged(fullNameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(fullname: event.fullName));
  }

  // Handle the API call for sign-up
  void _onSignUpApi(SignUpApi event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(signupStatus: SignUpStatus.loading));

    Map<String, String> data = {
      'mobile_no':"+91"+state.phoneNo,
      'name': state.fullName,
      'email': state.email,
    };

    try {
      // Ignore SSL errors (for development only)
      HttpOverrides.global = MyHttpOverrides();

      // First, make a GET request to retrieve the CSRF token and cookies
      final getResponse = await http.get(Uri.parse('https://myzerobroker.com/register'));

      print('GET request status: ${getResponse.statusCode}');
      print('GET response body: ${getResponse.body}');

      if (getResponse.statusCode == 200) {
        final csrfToken = extractCsrfToken(getResponse.body);

        if (csrfToken.isEmpty) {
          emit(state.copyWith(
            signupStatus: SignUpStatus.error,
            message: 'CSRF token not found.',
          ));
          return;
        }

        final cookies = getResponse.headers['set-cookie'];

        final response = await http.post(
          Uri.parse('https://myzerobroker.com/api/register'),
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
            signupStatus: SignUpStatus.success,
            message: responseData['message'] ?? 'Registered successfully.',
          ));
        } else {
          var responseData = jsonDecode(response.body);
          emit(state.copyWith(
            signupStatus: SignUpStatus.error,
            message: responseData['message'] ?? 'Some error occurred.',
          ));
        }
      } else {
        emit(state.copyWith(
          signupStatus: SignUpStatus.error,
          message: 'Failed to fetch CSRF token.',
        ));
      }
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(
        signupStatus: SignUpStatus.error,
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

// Custom HttpOverrides to ignore SSL certificate errors
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
