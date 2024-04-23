import 'package:dio/dio.dart';
import 'package:network_layer_with_dio/number_extension.dart';
import 'network_request.dart';
import 'network_response.dart';

abstract class NetworkService {
  Future<NetworkResponse<Model>>? execute<Model>(
      NetworkRequest request, Model Function(dynamic) parser,
      {ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      Iterable<Interceptor>? interceptors});
}

class NetworkServiceImpl implements NetworkService {
  final Dio dio;

  final Map<String, String> _headers = <String, String>{};

  NetworkServiceImpl({
    required this.dio,
  });

  @override
  Future<NetworkResponse<Model>>? execute<Model>(
      NetworkRequest request, Model Function(dynamic) parser,
      {ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      Iterable<Interceptor>? interceptors}) async {
    try {
      if (interceptors != null) {
        dio.interceptors.addAll(interceptors);
      }

      final response = await dio.request(
        request.path,
        data: request.requestBody,
        queryParameters: request.queryParams,
        options: Options(
          method: request.type.name,
          headers: _headers,
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode?.isInRange(200, 299) == true) {
        final data = parser(response.data);
        return NetworkResponse.success(data, response.statusCode);
      }
      return NetworkResponse.failure("Unhandled error", response.statusCode);
    } on DioException catch (error) {
      var errorText =
          '${error.response?.data ?? 'There was an error, please try again'}';
      errorText = errorText.trim();
      switch (error.response?.statusCode) {
        case 400:
          return NetworkResponse.failure(errorText, error.response?.statusCode);
        case 401:
          return NetworkResponse.failure(errorText, error.response?.statusCode);
        case 403:
          return NetworkResponse.failure(errorText, error.response?.statusCode);
        case 404:
          return NetworkResponse.failure(errorText, error.response?.statusCode);
        case 409:
          return NetworkResponse.failure(errorText, error.response?.statusCode);
        default:
          return NetworkResponse.failure(errorText, error.response?.statusCode);
      }
    }
  }
}
