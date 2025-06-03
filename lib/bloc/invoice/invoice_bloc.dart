import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_zero_broker/data/models/invoice_model.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceInitial()) {
    on<FetchInvoices>((event, emit) async {
      emit(InvoiceLoading());
      try {
        final userDetails = locator.get<UserDetailsDependency>();
        final userId = userDetails.id;
        final uri =
            Uri.parse("https://www.myzerobroker.com/api/user/$userId/invoices");

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          print('Response: $jsonResponse');
          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse['data'] is List) {
            final invoices = (jsonResponse['data'] as List)
                .map((item) => Invoice.fromJson(item as Map<String, dynamic>))
                .toList();
            emit(InvoiceLoaded(invoices));
          } else {
            emit(InvoiceError('Invalid response format'));
          }
        } else {
          final errorResponse = jsonDecode(response.body);
          final errorMessage =
              errorResponse['message'] ?? 'Failed to load invoices';
          emit(InvoiceError(
              'Server error: $errorMessage (Status: ${response.statusCode})'));
        }
      } catch (e) {
        print('Error fetching invoices: $e');
        if (e is http.ClientException) {
          emit(InvoiceError('Network error: Please check your connection'));
        } else if (e is FormatException) {
          emit(InvoiceError('Invalid JSON format'));
        } else {
          emit(InvoiceError('Unexpected error: $e'));
        }
      }
    });
  }
}
