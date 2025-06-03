part of 'invoice_bloc.dart';

sealed class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class FetchInvoices extends InvoiceEvent {
  const FetchInvoices();

  @override
  List<Object> get props => [];
}