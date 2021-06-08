import 'package:dio/dio.dart';
import 'package:instabug_flutter/models/network_data.dart';
import 'package:instabug_flutter/NetworkLogger.dart';

class InstabugDioInterceptor extends Interceptor {
  static final Map<int, NetworkData> _requests = <int, NetworkData>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final NetworkData data = NetworkData();
    data.startTime = DateTime.now();
    _requests[options.hashCode] = data;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    NetworkLogger.networkLog(_map(response));
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    NetworkLogger.networkLog(_map(err.response));
    handler.next(err);
  }

  static NetworkData _getRequestData(int requestHashCode) {
    if (_requests[requestHashCode] != null) {
      return _requests.remove(requestHashCode);
    }
    return null;
  }

  NetworkData _map(Response response) {
    final NetworkData data = _getRequestData(response.requestOptions.hashCode);
    data.endTime = DateTime.now();
    data.duration = data.endTime.millisecondsSinceEpoch - data.startTime.millisecondsSinceEpoch;
    final Map<String, dynamic> responseHeaders = <String, dynamic>{};
    response.headers.forEach((String name, dynamic value) => responseHeaders[name] = value);
    data.url = response.requestOptions.uri.toString();
    data.method = response.requestOptions.method;
    data.requestBody = response.requestOptions.data;
    data.requestHeaders = response.requestOptions.headers;
    data.contentType = response.requestOptions.contentType.toString();
    data.status = response.statusCode;
    data.responseBody = response.data;
    data.responseHeaders = responseHeaders;
    return data;
  }
}
