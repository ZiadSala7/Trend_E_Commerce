import 'package:equatable/equatable.dart';

import 'invoice_item.dart';

class Invoice extends Equatable {
  const Invoice({
    this.items = const [],
    this.customerName = 'Walk-in Customer',
    this.accountName = 'Cash Account',
    this.salesman = 'Default rep',
    this.paymentType = 'Cash',
    this.exchangeRate = 90000,
    this.exchangeCurrency = 'LBP',
  });

  final List<InvoiceItem> items;
  final String customerName;
  final String accountName;
  final String salesman;
  final String paymentType;
  final double exchangeRate;
  final String exchangeCurrency;

  double get subtotal =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  double get totalDiscount =>
      items.fold(0, (sum, item) => sum + item.discountAmount);

  double get total => subtotal - totalDiscount;

  Invoice copyWith({
    List<InvoiceItem>? items,
    String? customerName,
    String? accountName,
    String? salesman,
    String? paymentType,
    double? exchangeRate,
    String? exchangeCurrency,
  }) {
    return Invoice(
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      accountName: accountName ?? this.accountName,
      salesman: salesman ?? this.salesman,
      paymentType: paymentType ?? this.paymentType,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      exchangeCurrency: exchangeCurrency ?? this.exchangeCurrency,
    );
  }

  @override
  List<Object?> get props => [
        items,
        customerName,
        accountName,
        salesman,
        paymentType,
        exchangeRate,
        exchangeCurrency,
      ];
}
