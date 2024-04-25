import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/dio_config.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_service.dart';
import 'package:network_layer_with_dio/data_layer/repository/phone_repository.dart';
import 'package:network_layer_with_dio/presentation_layer/phone_view_model.dart';

class DiContainer {
  static final getIt = GetIt.instance;

  static setUpDi() {
    getIt.registerFactory(
        () => DioConfig(baseUrl: 'https://dummyjson.com/', dio: Dio()));

    getIt.registerFactory(() => NetworkService(getIt<DioConfig>().makeDio()));

    getIt.registerFactory<PhoneRepository>(
        () => PhoneRepositoryImpl(networtkService: getIt()));

    getIt.registerFactory(() => PhoneViewModel(phoneRepository: getIt()));
  }
}
