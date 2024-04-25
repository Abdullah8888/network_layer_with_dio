//import 'package:network_layer_with_dio/string_extension.dart';

enum NetworkRequestType {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE;

  factory NetworkRequestType.fromString(String? type) {
    switch (type) {
      case 'GET':
        return NetworkRequestType.GET;
      case 'POST':
        return NetworkRequestType.POST;
      case 'PUT':
        return NetworkRequestType.PUT;
      case 'PATCH':
        return NetworkRequestType.PATCH;
      case 'DELETE':
        return NetworkRequestType.DELETE;
      case null:
        return NetworkRequestType.DELETE;
      default:
        return NetworkRequestType.GET;
    }
  }
}

class NetworkRequest {
  const NetworkRequest({
    required this.type,
    required this.path,
    this.requestBody,
    this.queryParams,
    this.headers,
  });

  final NetworkRequestType type;
  final String path;
  final Map<String, dynamic>? requestBody;
  final Map<String, dynamic>? queryParams;
  final Map<String, String>? headers;
}
