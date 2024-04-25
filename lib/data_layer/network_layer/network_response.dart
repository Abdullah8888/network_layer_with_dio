class NetworkResponse<Model> {
  Model? data;
  String? errMessage;
  int? statusCode;
  NetworkResponse({this.data, this.errMessage, this.statusCode});
  factory NetworkResponse.success(Model? data, int? statusCode) {
    return NetworkResponse<Model>(data: data, statusCode: statusCode);
  }

  factory NetworkResponse.failure(String message, int? statusCode) {
    return NetworkResponse<Model>(errMessage: message, statusCode: statusCode);
  }

  // TResult either<TResult extends Object?>({
  //   required Function(Model? data)? success,
  //   required Function(String? errMessage) failure,
  // }) {
  //   if (success != null) {
  //     return success(data);
  //   }
  //   return failure(errMessage);
  // }
}
