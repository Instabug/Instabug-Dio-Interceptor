
import 'package:dio/dio.dart';

class InstabugDioInterceptor extends Interceptor { 
  
  @override
  onRequest(RequestOptions options) {
    print(options);
  }

  @override
  onResponse(Response response) {
    print(response);
  }

  @override
  onError(DioError e) {
    print(e);
  }
}