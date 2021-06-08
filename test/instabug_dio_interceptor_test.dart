import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_dio_interceptor/instabug_dio_interceptor.dart';
import 'package:mockito/mockito.dart';

class MockInstabugDioInterceptor extends Mock implements InstabugDioInterceptor {}

void main() {
  test('onResponse Test', () async {
    final MockInstabugDioInterceptor instabugDioInterceptor = MockInstabugDioInterceptor();
    final Dio dio = Dio();
    dio.interceptors.add(instabugDioInterceptor);
    final RequestInterceptorHandler requestHandler = RequestInterceptorHandler();
    final ResponseInterceptorHandler responseHandler = ResponseInterceptorHandler();

    when<void>(instabugDioInterceptor.onRequest(any, requestHandler)).thenReturn(null);
    when<void>(instabugDioInterceptor.onResponse(any, responseHandler)).thenReturn(null);
    try {
      await dio.get<dynamic>('http://dummy.restapiexample.com/api/v1/employees');
    } on DioError {
      // ignored
    }
    verify<void>(instabugDioInterceptor.onRequest(any, requestHandler));
    verify<void>(instabugDioInterceptor.onResponse(any, responseHandler));
  });

  test('onError Test', () async {
    final MockInstabugDioInterceptor instabugDioInterceptor = MockInstabugDioInterceptor();
    final Dio dio = Dio();
    dio.interceptors.add(instabugDioInterceptor);
    final RequestInterceptorHandler requestHandler = RequestInterceptorHandler();
    final ErrorInterceptorHandler errorHandler = ErrorInterceptorHandler();

    when<void>(instabugDioInterceptor.onRequest(any, requestHandler)).thenReturn(null);
    when<void>(instabugDioInterceptor.onError(any, errorHandler)).thenReturn(null);
    try {
      await dio.get<dynamic>('http://dummy.restapiexample.com/api/v1/employee');
    } on DioError {
      // ignored
    }
    verify<void>(instabugDioInterceptor.onRequest(any, requestHandler));
    verify<void>(instabugDioInterceptor.onError(any, errorHandler));
  });

  test('Stress Test', () async {
    final MockInstabugDioInterceptor instabugDioInterceptor = MockInstabugDioInterceptor();
    final Dio dio = Dio();
    dio.interceptors.add(instabugDioInterceptor);
    final RequestInterceptorHandler requestHandler = RequestInterceptorHandler();
    final ResponseInterceptorHandler responseHandler = ResponseInterceptorHandler();

    when<void>(instabugDioInterceptor.onRequest(any, requestHandler)).thenReturn(null);
    when<void>(instabugDioInterceptor.onResponse(any, responseHandler)).thenReturn(null);
    for (int i = 0; i < 1000; i++) {
      try {
        dio.get<dynamic>('http://dummy.restapiexample.com/api/v1/employees');
      } on DioError {
        // ignored
      }
    }
    verify<void>(instabugDioInterceptor.onRequest(any, requestHandler)).called(1000);
  });
}
