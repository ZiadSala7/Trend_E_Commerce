import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/mock_product_data.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getProducts({
    String? categoryId,
    String? search,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    var list = List<Product>.from(MockProductData.products);
    if (categoryId != null && categoryId != 'all') {
      list = list.where((p) => p.categoryId == categoryId).toList();
    }
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Future<List<Category>> getCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return List<Category>.from(MockProductData.categories);
  }
}
