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

  void _onSendContactMessage(SendContactMessage event, Emitter<ContactState> emit) async {
    emit(state.copyWith(status: ContactStatus.sending));

    try {
      // Bypass SSL for development purposes
      HttpOverrides.global = MyHttpOverrides();

      // Step 1: GET request to fetch CSRF token and cookies
           final getResponse = await http.get(Uri.parse('https://myzerobroker.com/contact-us'));

      if (getResponse.statusCode != 200) {
        emit(state.copyWith(
          status: ContactStatus.failure,
          message: 'Failed to fetch CSRF token. Server responded with status code: ${getResponse.statusCode}.',
        ));
        return;
      }

      // Log response headers and body for debugging
      print("GET Response Headers: ${getResponse.headers}");
      print("GET Response Body: ${getResponse.body}");

      // Step 2: Extract CSRF token
      final csrfToken = _extractCsrfToken(getResponse.body);
      print(csrfToken);
      if (csrfToken.isEmpty) {
        emit(state.copyWith(
          status: ContactStatus.failure,
          message: 'Failed to extract CSRF token from the response.',
        ));
        return;
      }

      // Step 3: Extract cookies from the response headers
      final cookies = getResponse.headers['set-cookie'];
      if (cookies == null || cookies.isEmpty) {
        emit(state.copyWith(
          status: ContactStatus.failure,
          message: 'Failed to extract cookies from the response.',
        ));
        return;
      }

      print('CSRF Token: $csrfToken');
      print('Cookies: $cookies');

      // Step 4: POST request to send the message
      final postResponse = await http.post(
        Uri.parse('https://myzerobroker.com/send-message'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': 'VLPCjs86bXOYfjXWqHgUgHbr8PrcpDPK2za0dgd1',
          'Accept': 'application/json',
          'Cookie': 'XSRF-TOKEN=eyJpdiI6InBFN3VoYjhaVS9KM1hqWnM1bmZDeFE9PSIsInZhbHVlIjoiZTE5Um0vNHEvejlWVnZxVlZXb0Y4S0d1V2tZZkExSGp6b1hraGF0dklic01yZXl2clg4aHNpRkhVb2wxOUNoMGZMcTg1M25YcFJ1anZVUUhvQU9vUDRmMGhhUmRaVFp0Z1dPcXVnalpTakRVZk5lbGJ5TkI3UGNHZ1ZxOFhrZnkiLCJtYWMiOiI2NTg5Mzg5MGFlNGM3ZGJhMDY1MzExY2FkM2ZmYzczNzlmNWVkMTM4ZDM1NGMyNDdkZDM2ZmQ3OTMxMzE5N2JhIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6IjNLN3ZuNU9CQVlaVCtuWXFDblFUeFE9PSIsInZhbHVlIjoiR3UzMnZpbHFhdkpjTUo4VTZxdURnSFEva0RjWUpwTnBHeUNTT25yMDZIcTB5eTFQcXBweERYNkplQ2JhdFFUMUgycUc5ZCtHdGNnRXE3QXhDbHJjSkZ4a3kzQTBRMmNyR2pKemMwRytscDhIQldwMlQ2SENtZnhSL3lXVGFjVGgiLCJtYWMiOiI0ZmEzZjZkZTMyYzU4MWY4ZTc4MzZiMGZlOTFjMDBkOTc1ZWZiYTQ4ZWM3MzNlZTNkYmFkOTdhM2E5YzE0MDg0IiwidGFnIjoiIn0%3D',
        },
        body: jsonEncode({
          'full_name': event.name,
          'email': event.email,
          'message': event.message,
        }),
      );

      // Step 5: Handle response from the POST request
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

  // Helper method to extract CSRF Token from HTML response
  String _extractCsrfToken(String html) {
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
