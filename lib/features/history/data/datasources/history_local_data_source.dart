import '../models/invoice_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<InvoiceModel>> getMockInvoices();
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  @override
  Future<List<InvoiceModel>> getMockInvoices() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      InvoiceModel(
        id: '1',
        invoiceNumber: 'INV-20614',
        date: 'Jun 24, 2026',
        kitsInfo: '50 Kits',
        amount: 6499.00,
        sectionCategory: 'This Month',
      ),
      InvoiceModel(
        id: '2',
        invoiceNumber: 'INV-20614',
        date: 'Jun 24, 2026',
        kitsInfo: '50 Kits',
        amount: 6499.00,
        sectionCategory: 'This Month',
      ),
      InvoiceModel(
        id: '3',
        invoiceNumber: 'INV-20614',
        date: 'Jun 24, 2026',
        kitsInfo: '50 Kits',
        amount: 6499.00,
        sectionCategory: 'This Month',
      ),
      // June, 2026
      InvoiceModel(
        id: '4',
        invoiceNumber: 'INV-20614',
        date: 'Jun 24, 2026',
        kitsInfo: '50 Kits',
        amount: 6499.00,
        sectionCategory: 'June, 2026',
      ),
      InvoiceModel(
        id: '5',
        invoiceNumber: 'INV-20614',
        date: 'Jun 24, 2026',
        kitsInfo: '50 Kits',
        amount: 6499.00,
        sectionCategory: 'June, 2026',
      ),
    ];
  }
}