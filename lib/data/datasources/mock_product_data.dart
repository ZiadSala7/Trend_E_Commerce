import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

class MockProductData {
  MockProductData._();

  static const List<Category> categories = [
    Category(id: 'all', name: 'All'),
    Category(id: 'condiments', name: 'Condiments & Preserves'),
    Category(id: 'sweets', name: 'Sweet Snacks'),
    Category(id: 'others', name: 'Others'),
  ];

  static final List<Product> products = [
    const Product(
      id: '1',
      name: 'White Vinegar 950ml',
      price: 0.68,
      stock: 14,
      categoryId: 'condiments',
    ),
    const Product(
      id: '2',
      name: 'Grape Vinegar 50ml',
      price: 1.02,
      stock: 0,
      categoryId: 'condiments',
    ),
    const Product(
      id: '3',
      name: 'Strawberry Jam',
      price: 1.25,
      stock: 40,
      categoryId: 'condiments',
    ),
    const Product(
      id: '4',
      name: 'Apricot Jam',
      price: 2.20,
      stock: 7,
      categoryId: 'condiments',
    ),
    const Product(
      id: '5',
      name: 'Mixed Pickled Cucumber',
      price: 2.39,
      stock: 3,
      categoryId: 'condiments',
    ),
    const Product(
      id: '6',
      name: 'Green Hot Pepper 600grs',
      price: 1.36,
      stock: 0,
      categoryId: 'condiments',
    ),
    const Product(
      id: '7',
      name: 'Strawberry Jam 12*450grs',
      price: 1.25,
      stock: 20,
      categoryId: 'condiments',
    ),
    const Product(
      id: '8',
      name: 'Pickled Wild Cucumber',
      price: 2.39,
      stock: 8,
      categoryId: 'condiments',
    ),
    const Product(
      id: '9',
      name: 'Chocolate Bar',
      price: 1.99,
      stock: 25,
      categoryId: 'sweets',
    ),
    const Product(
      id: '10',
      name: 'Honey Jar 500g',
      price: 3.50,
      stock: 5,
      categoryId: 'others',
    ),
  ];
}
