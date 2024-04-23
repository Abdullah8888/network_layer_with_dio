import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
//import 'package:my_naija_market/src/network/network.dart'; // Replace with your actual network service class
import 'package:mockito/mockito.dart';
//import 'package:my_naija_market/src/shared/utils/utils.dart';
import 'package:network_layer_with_dio/network_layer/network_request.dart';
import 'package:network_layer_with_dio/network_layer/network_service.dart';
import 'package:network_layer_with_dio/number_extension.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  group('NetworkService', () {
    late NetworkServiceImpl networkService;
    late Dio mockDio; // Create a mock Dio client
    late DioAdapter dioAdapterMock;

    setUp(() {
      mockDio = Dio(); // Initialize the mock Dio client
      dioAdapterMock = DioAdapter(dio: mockDio);
      networkService = NetworkServiceImpl(dio: mockDio);
    });

    tearDown(() {
      print("done, object should be dispose here");
    });

    test('Test perform a get request with 200 at status code', () async {
      // Arrange
      NetworkRequest request =
          const NetworkRequest(type: NetworkRequestType.GET, path: 'api/test');

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

    test('Test perform a get request with 200 at status code', () async {
      // Arrange
      NetworkRequest request =
          const NetworkRequest(type: NetworkRequestType.GET, path: 'api/test');

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
  });
}

class SampleResponseModel {
  final String? greeting;
  SampleResponseModel({this.greeting});
  factory SampleResponseModel.fromJson(dynamic json) {
    return SampleResponseModel(greeting: json["greeting"]);
  }
}
