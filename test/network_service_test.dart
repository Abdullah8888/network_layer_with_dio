import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/dio_config.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_request.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_service.dart';
import 'package:network_layer_with_dio/number_extension.dart';

class IOHttpClientAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  group('NetworkService Test', () {
    late NetworkService networkService;
    late Dio mockDio;
    late DioAdapter httpClientAdapterMock;

    setUp(() {
      mockDio = Dio();
      httpClientAdapterMock = DioAdapter(dio: mockDio);
      final dioConfig = DioConfig(baseUrl: 'https://test/api/', dio: mockDio);
      dioConfig.dio.httpClientAdapter = httpClientAdapterMock;
      networkService = NetworkService(dioConfig.makeDio());
    });

    tearDown(() {
      httpClientAdapterMock.close();
    });

    test(
        'Test should perform a GET request and return a successful response and status code',
        () async {
      // Arrange
      NetworkRequest request = const NetworkRequest(
          type: NetworkRequestType.GET, path: 'test-products');

      httpClientAdapterMock.onGet(request.path, (server) {
        server.reply(200, {"greeting": "Hello John"});
      });

      // When
      final response = await networkService.execute(
        request,
        SampleResponseModel.fromJson,
      );

      // Assert
      expect(request.type, NetworkRequestType.GET);
      expect(response!.statusCode?.isInRange(200, 299), true);
      expect(response.data?.greeting, "Hello John");
    });

    test(
        'Test should perform a GET request and return a Bad Gateway response with its status code.',
        () async {
      // Arrange
      NetworkRequest request = const NetworkRequest(
          type: NetworkRequestType.GET, path: 'test-products');

      httpClientAdapterMock.onGet(request.path, (server) {
        server.reply(502, "Bad Gateway response");
      });

      //When
      final response = await networkService.execute(
        request,
        (p0) => p0,
      );

      // Assert
      expect(request.type, NetworkRequestType.GET);
      expect(response!.statusCode, 502);
      expect(response.errMessage, "Bad Gateway response");
    });
  });
}

class SampleResponseModel {
  final String? greeting;
  SampleResponseModel({this.greeting});
  factory SampleResponseModel.fromJson(dynamic json) {
    return SampleResponseModel(greeting: json["greeting"]);
  }
}
