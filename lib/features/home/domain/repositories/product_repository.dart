import '../entities/category.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int? categoryId, String? search});
  Future<List<Category>> getCategories();
}
