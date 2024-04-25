import 'package:network_layer_with_dio/data_layer/repository/phone_repository.dart';
import 'package:flutter/material.dart';

class PhoneViewModel {
  final PhoneRepository phoneRepository;
  const PhoneViewModel({required this.phoneRepository});

  Future<void> fetchPhones() async {
    try {
      var result = await phoneRepository.fetchPhones();

      if (result.hasResponse) {
        result.fold((failure) {
          debugPrint("error is ${failure.message}");
        }, (phoneModel) {
          debugPrint("data is ${phoneModel?.products?.first.title}");
        });
      } else {
        debugPrint("error is ${result.left.message}");
      }
    } catch (error) {
      debugPrint("error is ${error.toString()}");
    }
  }
}
