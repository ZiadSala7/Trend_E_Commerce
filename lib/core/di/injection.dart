import '../../data/repositories/invoice_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/repositories/product_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<ProductRepository>(ProductRepositoryImpl.new);
  sl.registerLazySingleton<InvoiceRepository>(InvoiceRepositoryImpl.new);
}
