import 'package:dio/dio.dart';

class DioConfig {
  final String baseUrl;
  final Dio dio;
  DioConfig({required this.baseUrl, required this.dio});

  Dio makeDio() {
    dio.options.baseUrl = baseUrl;
    return dio;
  }
}
