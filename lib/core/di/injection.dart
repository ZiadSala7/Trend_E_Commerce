import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/home/data/repositories/invoice_repository_impl.dart';
import '../../features/home/data/repositories/product_repository_impl.dart';
import '../../features/home/domain/repositories/invoice_repository.dart';
import '../../features/home/domain/repositories/product_repository.dart';
import '../api/api_consumer.dart';
import '../api/dio_consumer.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(api: sl()),
  );
  sl.registerLazySingleton<InvoiceRepository>(InvoiceRepositoryImpl.new);
}
