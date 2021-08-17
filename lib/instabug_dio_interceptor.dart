import 'package:dio/dio.dart';
import 'package:instabug_flutter/models/network_data.dart';
import 'package:instabug_flutter/NetworkLogger.dart';

class InstabugDioInterceptor extends Interceptor {
  static final Map<int, NetworkData> _requests = <int, NetworkData>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final NetworkData data =
        NetworkData(startTime: DateTime.now(), url: options.uri.toString(), method: options.method);
    _requests[options.hashCode] = data;
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    NetworkLogger.networkLog(_map(response));
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      NetworkLogger.networkLog(_map(err.response!));
    }

    handler.next(err);
  }

  static NetworkData _getRequestData(int requestHashCode) {
    final NetworkData d = _requests[requestHashCode]!;
    _requests.remove(requestHashCode);
    return d;
  }

  NetworkData _map(Response<dynamic> response) {
    final NetworkData data = _getRequestData(response.requestOptions.hashCode);
    final Map<String, dynamic> responseHeaders = <String, dynamic>{};
    response.headers.forEach((String name, dynamic value) => responseHeaders[name] = value);
    return data.copyWith(
      endTime: DateTime.now(),
      duration: data.endTime!.millisecondsSinceEpoch - data.startTime.millisecondsSinceEpoch,
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      requestBody: response.requestOptions.data,
      requestHeaders: response.requestOptions.headers,
      contentType: response.requestOptions.contentType,
      status: response.statusCode,
      responseBody: response.data,
      responseHeaders: responseHeaders,
    );
  }
}
