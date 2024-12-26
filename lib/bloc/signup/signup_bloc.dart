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
    on<UpdateProfileApi>(_onUpdateProfile);
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



void _onUpdateProfile(UpdateProfileApi event, Emitter<SignUpState> emit) async {
  emit(state.copyWith(signupStatus: SignUpStatus.loading));

  Map<String, String> data = {
    'mobile_no': "+91" + state.phoneNo,
    'name': state.fullName,
    'email': state.email,
  };

  try {
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
      if (cookies == null || cookies.isEmpty) {
        emit(state.copyWith(
          signupStatus: SignUpStatus.error,
          message: 'Cookies not found.',
        ));
        return;
      }

      // Extract and clean cookies
      List<String> cookiesList = cookies.split(',');
      List<String> cleanedCookies = cookiesList.map((cookie) {
        return cookie.split(';')[0].trim(); // Keep only the part before the first `;`
      }).toList();

      // Ensure cookies are formatted correctly
      String formattedCookies = cleanedCookies.join(';');
      print('Formatted Cookies: $formattedCookies');

      final response = await http.put(
        Uri.parse('https://myzerobroker.com/user/profile/update'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': csrfToken,
          'Accept': 'application/json',
          'Cookie': formattedCookies,
          'Upgrade-Insecure-Requests': '1', // Include the new header
        },
        body: jsonEncode(data),
      );

      print('PUT request status: ${response.statusCode}');
      print('PUT response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        emit(state.copyWith(
          signupStatus: SignUpStatus.success,
          message: responseData['message'] ?? 'Profile updated successfully.',
        ));
      } else {
        var responseData = jsonDecode(response.body);
        emit(state.copyWith(
          signupStatus: SignUpStatus.error,
          message: responseData['message'] ?? 'Failed to update profile.',
        ));
      }
    } else {
      emit(state.copyWith(
        signupStatus: SignUpStatus.error,
        message: 'Failed to fetch CSRF token and cookies.',
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
