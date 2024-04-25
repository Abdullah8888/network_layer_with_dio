import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
//import 'package:my_naija_market/src/network/network.dart'; // Replace with your actual network service class
import 'package:mockito/mockito.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/dio_config.dart';
//import 'package:my_naija_market/src/shared/utils/utils.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_request.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_response.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_service.dart';
import 'package:network_layer_with_dio/domain_layer/error_model.dart';
import 'package:network_layer_with_dio/either_helper.dart';
import 'package:network_layer_with_dio/number_extension.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  group('NetworkService', () {
    late NetworkService networkService;
    late Dio mockDio;
    late DioAdapter dioAdapterMock;

    setUp(() {
      mockDio = Dio();
      dioAdapterMock = DioAdapter(dio: mockDio);
      final dioConfig = DioConfig(baseUrl: 'https://test/api/', dio: mockDio);
      networkService = NetworkService(dio: dioConfig.makeDio());
      networkService.dio.httpClientAdapter = dioAdapterMock;
    });

    tearDown(() {
      networkService.dio.httpClientAdapter.close();
      print("done, object should be dispose here");
    });

    test(
        'Test should perform a get request and return a success response and status code',
        () async {
      // Arrange
      NetworkRequest request = const NetworkRequest(
          type: NetworkRequestType.GET, path: 'test-products');

      dioAdapterMock.onGet(request.path, (server) {
        server.reply(200, {"greeting": "Hello John"});
      });

      // When
      final response = await networkService.execute(
        request,
        SampleResponseModel.fromJson,
      );

      // Assert
      expect(response!.statusCode?.isInRange(200, 299), true);
      expect(response.data?.greeting, "Hello John");
    });

    test('Test should a get request and return 502 as the response status code',
        () async {
      // Arrange
      NetworkRequest request = const NetworkRequest(
          type: NetworkRequestType.GET, path: 'test-products');

      dioAdapterMock.onGet(request.path, (server) {
        server.reply(502, "Bad Gateway response");
      });

      //When
      final response = await networkService.execute(
        request,
        (p0) => p0,
      );

      // Assert
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
