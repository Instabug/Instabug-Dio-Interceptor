import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:instabug_dio_interceptor/InstabugDioInterceptor.dart';
import 'package:flutter_test/flutter_test.dart';


class MockInstabugDioInterceptor extends Mock implements InstabugDioInterceptor {}

main() {

  test('onResponse Test', () async {
    var instabugDioInterceptor = MockInstabugDioInterceptor();
    var dio = new Dio();
    dio.interceptors.add(instabugDioInterceptor);
    when(instabugDioInterceptor.onRequest(any)).thenReturn(null);
    when(instabugDioInterceptor.onResponse(any)).thenReturn(null);
    try {
      await dio.get("http://dummy.restapiexample.com/api/v1/employees");
    } on DioError { }
     verify(instabugDioInterceptor.onRequest(any));
     verify(instabugDioInterceptor.onResponse(any));
  });

  test('onError Test', () async {
    var instabugDioInterceptor = MockInstabugDioInterceptor();
    var dio = new Dio();
    dio.interceptors.add(instabugDioInterceptor);
    when(instabugDioInterceptor.onRequest(any)).thenReturn(null);
    when(instabugDioInterceptor.onError(any)).thenReturn(null);
    try {
      await dio.get("http://dummy.restapiexample.com/api/v1/employee");
    } on DioError { }
     verify(instabugDioInterceptor.onRequest(any));
     verify(instabugDioInterceptor.onError(any));
  });
}

