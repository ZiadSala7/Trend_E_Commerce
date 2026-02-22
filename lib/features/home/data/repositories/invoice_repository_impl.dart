import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  @override
  Future<void> saveInvoice(Invoice invoice) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> saveAndPrintInvoice(Invoice invoice) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
