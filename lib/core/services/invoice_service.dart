import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../../features/inventory/domain/entities/inventory_entity.dart';

class InvoiceService {
  /// Generates the PDF document and saves it locally WITHOUT opening it automatically.
  Future<String> downloadInvoice(InventoryItem item) async {
    final pdf = _buildPdfDocument(item);

    final output = await getTemporaryDirectory();
    final filePath = "${output.path}/Invoice_${item.serialNumber}.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("📂 PDF FILE DOWNLOADED LOCALLY AT: $filePath");
    return filePath;
  }

  /// Generates the PDF document and opens it immediately using OpenFile.
  Future<void> generateAndOpenInvoice(InventoryItem item) async {
    final filePath = await downloadInvoice(item);

    final result = await OpenFile.open(filePath);
    print("📱 OPEN FILE RESULT: ${result.message}");
  }

  pw.Document _buildPdfDocument(InventoryItem item) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('AO PAY LOCK KITS', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Purchase & Inventory Invoice', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
              pw.Divider(thickness: 2, color: PdfColors.blue),
              pw.SizedBox(height: 20),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Serial Number: ${item.serialNumber}', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Date: ${item.installedDate.day} ${_getMonthName(item.installedDate.month)}, ${item.installedDate.year}', style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Text('Assigned Customer: ${item.assignedUser}', style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 30),

              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.grey200,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Lock Kit Hardware & License'),
                    pw.Text('₹ 1,000.00'),
                  ],
                ),
              ),
              pw.Divider(),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Status: SUCCESS', style: pw.TextStyle(color: PdfColors.green, fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  String _getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}