import '../../features/home/data/repositories/invoice_repository_impl.dart';
import '../../features/home/data/repositories/product_repository_impl.dart';
import '../../features/home/domain/repositories/invoice_repository.dart';
import '../../features/home/domain/repositories/product_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<ProductRepository>(ProductRepositoryImpl.new);
  sl.registerLazySingleton<InvoiceRepository>(InvoiceRepositoryImpl.new);
}
