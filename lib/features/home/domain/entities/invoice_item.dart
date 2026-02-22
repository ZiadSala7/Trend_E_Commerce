import 'package:equatable/equatable.dart';

import 'product.dart';

class InvoiceItem extends Equatable {
  const InvoiceItem({
    required this.product,
    required this.quantity,
    this.discountPercent = 0,
    this.package = 'PCS',
  });

  final Product product;
  final int quantity;
  final double discountPercent;
  final String package;

  double get unitPrice => product.price;

  double get discountAmount =>
      (unitPrice * quantity * discountPercent) / 100;

  double get total => (unitPrice * quantity) - discountAmount;

  InvoiceItem copyWith({
    Product? product,
    int? quantity,
    double? discountPercent,
    String? package,
  }) {
    return InvoiceItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      discountPercent: discountPercent ?? this.discountPercent,
      package: package ?? this.package,
    );
  }

  @override
  List<Object?> get props => [product, quantity, discountPercent, package];
}
