import '../entities/invoice.dart';

abstract class InvoiceRepository {
  Future<void> saveInvoice(Invoice invoice);
  Future<void> saveAndPrintInvoice(Invoice invoice);
}
