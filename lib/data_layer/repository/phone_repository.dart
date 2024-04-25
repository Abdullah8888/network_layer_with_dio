import 'package:network_layer_with_dio/domain_layer/error_model.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_request.dart';
import 'package:network_layer_with_dio/data_layer/network_layer/network_service.dart';
import 'package:network_layer_with_dio/domain_layer/phone_model.dart';
import 'package:network_layer_with_dio/either_helper.dart';

abstract class PhoneRepository {
  Future<Either<ErrorModel, PhoneModel?>> fetchPhones();
}

class PhoneRepositoryImpl implements PhoneRepository {
  final NetworkService networtkService;
  PhoneRepositoryImpl({required this.networtkService});

  @override
  Future<Either<ErrorModel, PhoneModel?>> fetchPhones() async {
    try {
      NetworkRequest request = const NetworkRequest(
        type: NetworkRequestType.GET,
        path: 'products',
      );
      final response = await networtkService.execute(
        request,
        PhoneModel.fromJson,
      );

      return response?.data != null
          ? Right(response?.data)
          : Left(ErrorModel(message: '${response?.errMessage}'));
    } catch (e) {
      return Left(ErrorModel(message: 'An error occurred, ${e.toString()}'));
    }
  }
}
