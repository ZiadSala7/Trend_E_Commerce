import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.categoryId,
  });

  final String id;
  final String name;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? categoryId;

  bool get isInStock => stock > 0;

  @override
  List<Object?> get props => [id, name, price, stock, imageUrl, categoryId];
}
