import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_zero_broker/data/models/invoice_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class InvoiceViewPage extends StatelessWidget {
  final String recipientName;
  final Invoice invoice;

  const InvoiceViewPage({
    super.key,
    required this.recipientName,
    required this.invoice,
  });

  // Function to generate the PDF
  Future<Uint8List> _generatePdf(
      PdfPageFormat format, BuildContext context) async {
    final imageData = await DefaultAssetBundle.of(context)
        .load('assets/images/my_zero_broker_logo (2).png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());
    final pdf = pw.Document();
    final dateFormat =
        DateFormat('dd MMMM yyyy').format(invoice.invoiceDate).toUpperCase();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(image, width: 100, height: 100),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Date: $dateFormat',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    'Invoice No: ${invoice.invoiceNumber}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Name: $recipientName',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                defaultColumnWidth: const pw.FlexColumnWidth(1),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Plan Name',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Validity',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Price',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(invoice.planName),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(invoice.validity),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(invoice.price),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format, context),
        canChangePageFormat: false, // Optional: Disable page format changes
        canChangeOrientation: false, // Optional: Disable orientation changes
        canDebug: false, // Optional: Disable debug mode
        pdfFileName: 'invoice_${invoice.invoiceNumber}.pdf',
        // Set the default PDF file name
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Trigger the download/share action
          final pdfBytes = await _generatePdf(PdfPageFormat.a4, context);
          Printing.sharePdf(
            bytes: pdfBytes,
            filename: 'invoice_${invoice.invoiceNumber}.pdf',
          );
        },
        child: const Icon(Icons.download),
        tooltip: 'Download PDF',
      ),
    );
  }
}
