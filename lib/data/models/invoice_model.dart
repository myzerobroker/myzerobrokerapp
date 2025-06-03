// To parse this JSON data, do
//
//     final invoice = invoiceFromJson(jsonString);

import 'dart:convert';

Invoice invoiceFromJson(String str) => Invoice.fromJson(json.decode(str));

String invoiceToJson(Invoice data) => json.encode(data.toJson());

class Invoice {
    String invoiceNumber;
    DateTime invoiceDate;
    String planName;
    String planType;
    String validity;
    String price;

    Invoice({
        required this.invoiceNumber,
        required this.invoiceDate,
        required this.planName,
        required this.planType,
        required this.validity,
        required this.price,
    });

    factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceNumber: json["invoice_number"],
        invoiceDate: DateTime.parse(json["invoice_date"]),
        planName: json["plan_name"],
        planType: json["plan_type"],
        validity: json["validity"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "invoice_number": invoiceNumber,
        "invoice_date": "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "plan_name": planName,
        "plan_type": planType,
        "validity": validity,
        "price": price,
    };
}
