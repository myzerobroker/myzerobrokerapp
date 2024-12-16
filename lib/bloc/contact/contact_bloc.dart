import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(const ContactState()) {
    on<SendContactMessage>(_onSendContactMessage);
  }

  void _onSendContactMessage(
      SendContactMessage event, Emitter<ContactState> emit) async {
    emit(state.copyWith(status: ContactStatus.sending));

    try {
      // Use custom HttpOverrides to bypass SSL issues during development
      HttpOverrides.global = _CustomHttpOverrides();

      // Step 1: Fetch CSRF token and cookies
      final getResponse = await http.get(
        Uri.parse('https://myzerobroker.com/contact-us'),
        headers: {
          'Accept': 'text/html'
        }, // Ensure proper content type is requested
      );
      print(getResponse.body);

      if (getResponse.statusCode != 200) {
        emit(state.copyWith(
          status: ContactStatus.failure,
          message:
              'Failed to fetch CSRF token. Status code: ${getResponse.statusCode}',
        ));
        return;
      }

      // Extract CSRF token and cookies
      final csrfToken = _extractCsrfToken(getResponse.body);
      print(csrfToken);
      if (csrfToken.isEmpty) {
        emit(state.copyWith(
          status: ContactStatus.failure,
          message: 'Failed to extract CSRF token.',
        ));
        return;
      }
      print(getResponse.headers);

      final cookies = getResponse.headers['set-cookie'];
      if (cookies == null || cookies.isEmpty) {
        emit(state.copyWith(
          status: ContactStatus.failure,
          message: 'Failed to extract cookies.',
        ));
        return;
      }
      // print(cookies);

      // print('Extracted CSRF Token: $csrfToken');
      // print('Extracted Cookies: $cookies');

      List<String> cookiesList = cookies.split(',');
      print(cookiesList);

      // Process each cookie to remove unnecessary parts (everything after the first `;`)
      List<String> cleanedCookies = cookiesList.map((cookie) {
        return cookie
            .split(';')[0]
            .trim(); // Keep only the part before the first `;`
      }).toList();
      cleanedCookies[1] = cleanedCookies[2];
      cleanedCookies.removeAt(2);

      // Join the cleaned cookies into a formatted string
      String output = cleanedCookies.join(';');
      print(output);

      // Step 2: Send POST request with CSRF token and cookies
      final postResponse = await http.post(
        Uri.parse('https://myzerobroker.com/send-message'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': csrfToken,
          'Cookie': output, // Include the cookies in the request
        },
        body: jsonEncode({
          'full_name': event.name,
          'email': event.email,
          'message': event.message,
        }),
      );

      print(postResponse.body);

      // Handle POST response
      if (postResponse.statusCode == 200) {
        emit(state.copyWith(
          status: ContactStatus.success,
          message: 'Message sent successfully!',
        ));
      } else {
        final responseData = jsonDecode(postResponse.body);
        emit(state.copyWith(
          status: ContactStatus.failure,
          message: responseData['message'] ?? 'Failed to send the message.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ContactStatus.failure,
        message: 'An error occurred: $e',
      ));
    }
  }

  // Extract CSRF Token from HTML
  String _extractCsrfToken(String html) {
    final tokenRegex = RegExp(r'<meta name="csrf-token" content="(.*?)">');
    final match = tokenRegex.firstMatch(html);
    return match?.group(1) ?? '';
  }
}

// Custom HttpOverrides to bypass SSL certificate issues during development
class _CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
