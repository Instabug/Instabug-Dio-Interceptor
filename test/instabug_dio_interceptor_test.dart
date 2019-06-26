import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:instabug_dio_interceptor/InstabugDioInterceptor.dart';
import 'package:flutter_test/flutter_test.dart';


class MockInstabugDioInterceptor extends Mock implements InstabugDioInterceptor {}

void main() {
  test('onResponse Test', () async {
    final MockInstabugDioInterceptor instabugDioInterceptor = MockInstabugDioInterceptor();
    final Dio dio = Dio();
    dio.interceptors.add(instabugDioInterceptor);
    when<dynamic>(instabugDioInterceptor.onRequest(any)).thenReturn(null);
    when<dynamic>(instabugDioInterceptor.onResponse(any)).thenReturn(null);
    try {
      await dio.get<dynamic>("http://dummy.restapiexample.com/api/v1/employees");
    } on DioError { }
     verify<dynamic>(instabugDioInterceptor.onRequest(any));
     verify<dynamic>(instabugDioInterceptor.onResponse(any));
  });

  test('onError Test', () async {
    final MockInstabugDioInterceptor instabugDioInterceptor = MockInstabugDioInterceptor();
    final Dio dio = Dio();
    dio.interceptors.add(instabugDioInterceptor);
    when<dynamic>(instabugDioInterceptor.onRequest(any)).thenReturn(null);
    when<dynamic>(instabugDioInterceptor.onError(any)).thenReturn(null);
    try {
      await dio.get<dynamic>("http://dummy.restapiexample.com/api/v1/employee");
    } on DioError { }
     verify<dynamic>(instabugDioInterceptor.onRequest(any));
     verify<dynamic>(instabugDioInterceptor.onError(any));
  });

  test('Stress Test', () async {
    final MockInstabugDioInterceptor instabugDioInterceptor = MockInstabugDioInterceptor();
    final Dio dio = Dio();
    dio.interceptors.add(instabugDioInterceptor);
    when<dynamic>(instabugDioInterceptor.onRequest(any)).thenReturn(null);
    when<dynamic>(instabugDioInterceptor.onResponse(any)).thenReturn(null);
    for (int i = 0; i < 1000; i++) {
      try {
       dio.get<dynamic>("http://dummy.restapiexample.com/api/v1/employees");
      } on DioError { }
    }
     verify<dynamic>(instabugDioInterceptor.onRequest(any)).called(1000);
  });
}

