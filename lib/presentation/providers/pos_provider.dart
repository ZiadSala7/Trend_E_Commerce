import 'package:flutter/foundation.dart' hide Category;

import '../../core/di/injection.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/repositories/product_repository.dart';

class PosProvider extends ChangeNotifier {
  final ProductRepository _productRepo = sl<ProductRepository>();
  final InvoiceRepository _invoiceRepo = sl<InvoiceRepository>();

  List<Product> _products = [];
  List<Category> _categories = [];
  Invoice _invoice = const Invoice();
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSaving = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  Invoice get invoice => _invoice;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  int get cartItemCount =>
      _invoice.items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _productRepo.getProducts(
        categoryId: _selectedCategoryId == 'all' ? null : _selectedCategoryId,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );
      _categories = await _productRepo.getCategories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String id) {
    _selectedCategoryId = id;
    loadProducts();
  }

  void setSearch(String query) {
    _searchQuery = query;
    loadProducts();
  }

  void addToInvoice(Product product, {int quantity = 1}) {
    final items = List<InvoiceItem>.from(_invoice.items);
    final existingIndex = items.indexWhere((i) => i.product.id == product.id);
    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + quantity,
      );
    } else {
      items.add(InvoiceItem(product: product, quantity: quantity));
    }
    _invoice = _invoice.copyWith(items: items);
    notifyListeners();
  }

  void updateInvoiceItemQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeInvoiceItem(index);
      return;
    }
    final items = List<InvoiceItem>.from(_invoice.items);
    items[index] = items[index].copyWith(quantity: quantity);
    _invoice = _invoice.copyWith(items: items);
    notifyListeners();
  }

  void updateInvoiceItemDiscount(int index, double discount) {
    final items = List<InvoiceItem>.from(_invoice.items);
    items[index] = items[index].copyWith(discountPercent: discount);
    _invoice = _invoice.copyWith(items: items);
    notifyListeners();
  }

  void removeInvoiceItem(int index) {
    final items = List<InvoiceItem>.from(_invoice.items)..removeAt(index);
    _invoice = _invoice.copyWith(items: items);
    notifyListeners();
  }

  void updateInvoiceFields({
    String? customerName,
    String? accountName,
    String? salesman,
    String? paymentType,
    double? exchangeRate,
    String? exchangeCurrency,
  }) {
    _invoice = _invoice.copyWith(
      customerName: customerName,
      accountName: accountName,
      salesman: salesman,
      paymentType: paymentType,
      exchangeRate: exchangeRate,
      exchangeCurrency: exchangeCurrency,
    );
    notifyListeners();
  }

  Future<void> saveInvoice() async {
    _isSaving = true;
    notifyListeners();
    try {
      await _invoiceRepo.saveInvoice(_invoice);
      _invoice = const Invoice();
      notifyListeners();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> saveAndPrintInvoice() async {
    _isSaving = true;
    notifyListeners();
    try {
      await _invoiceRepo.saveAndPrintInvoice(_invoice);
      _invoice = const Invoice();
      notifyListeners();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
