import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required ApiConsumer api}) : _api = api;

  final ApiConsumer _api;

  @override
  Future<List<Product>> getProducts({int? categoryId, String? search}) async {
    if (categoryId == null) {
      return <Product>[];
    }
    final response = await _api.get<dynamic>(
      EndPoints.productByCategory,
      queryParameters: {'CategoryId': categoryId.toString()},
    );
    final items = _extractList(response)
        .whereType<Map<String, dynamic>>()
        .map((item) => _mapProduct(item, categoryId))
        .toList();
    if (search == null || search.isEmpty) {
      return items;
    }
    final q = search.toLowerCase();
    return items.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await _api.get<dynamic>(EndPoints.categories);
    return _extractList(
      response,
    ).whereType<Map<String, dynamic>>().map(_mapCategory).toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'] ?? data['result'] ?? data['items'];
      if (inner is List) return inner;
    }
    return const [];
  }

  Category _mapCategory(Map<String, dynamic> json) {
    return Category(
      id: json['categoryId'] is num
          ? (json['categoryId'] as num).toInt()
          : int.tryParse(json['categoryId']?.toString() ?? '') ?? 0,
      name: json['categoryName']?.toString() ?? '',
    );
  }

  Product _mapProduct(Map<String, dynamic> json, int categoryId) {
    final price = json['itemPrice'];
    final quantity = json['quantity'];
    return Product(
      id: json['itemId']?.toString() ?? '',
      name: json['itemName']?.toString() ?? '',
      price: price is num ? price.toDouble() : 0,
      stock: quantity is num ? quantity.toInt() : 0,
      imageUrl: json['itemImageBase64'] as String?,
      categoryId: categoryId,
    );
  }
}
