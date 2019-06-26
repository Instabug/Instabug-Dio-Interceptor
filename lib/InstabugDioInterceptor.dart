
import 'package:dio/dio.dart';

class InstabugDioInterceptor extends Interceptor { 
  
  @override
  dynamic onRequest(RequestOptions options) {
    print(options);
  }

  @override
  dynamic onResponse(Response  response) {
    print(response);
  }

  @override
  dynamic onError(DioError err) {
    print(err);
  }
}