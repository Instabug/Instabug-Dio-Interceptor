import 'package:dio/dio.dart';
import 'package:instabug_flutter/NetworkLogger.dart';
import 'package:instabug_flutter/models/network_data.dart';

class InstabugDioInterceptor extends Interceptor {
  static final Map<int, NetworkData> _requests = <int, NetworkData>{};
  static final NetworkLogger _networklogger = NetworkLogger();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final NetworkData data = NetworkData(
        startTime: DateTime.now(),
        url: options.uri.toString(),
        method: options.method);
    _requests[options.hashCode] = data;
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    final NetworkData data = _map(response);
    _networklogger.networkLog(data);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final NetworkData data = _map(err.response!);
      _networklogger.networkLog(data);
    }

    handler.next(err);
  }

  static NetworkData _getRequestData(int requestHashCode) {
    final NetworkData data = _requests[requestHashCode]!;
    _requests.remove(requestHashCode);
    return data;
  }

  NetworkData _map(Response<dynamic> response) {
    final NetworkData data = _getRequestData(response.requestOptions.hashCode);
    final Map<String, dynamic> responseHeaders = <String, dynamic>{};
    final DateTime endTime = DateTime.now();

    response.headers
        .forEach((String name, dynamic value) => responseHeaders[name] = value);

    String responseContentType = '';
    if (responseHeaders.containsKey('content-type')) {
      responseContentType = responseHeaders['content-type'].toString();
    }

    return data.copyWith(
      endTime: endTime,
      duration: endTime.difference(data.startTime).inMicroseconds,
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      requestBody: response.requestOptions.data.toString(),
      requestHeaders: response.requestOptions.headers,
      requestContentType: response.requestOptions.contentType,
      status: response.statusCode,
      responseBody: response.data.toString(),
      responseHeaders: responseHeaders,
      responseContentType: responseContentType,
    );
  }
}
