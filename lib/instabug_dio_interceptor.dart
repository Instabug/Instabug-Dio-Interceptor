import 'package:dio/dio.dart';
import 'package:instabug_flutter/NetworkLogger.dart';
import 'package:instabug_flutter/models/network_data.dart';

class InstabugDioInterceptor extends Interceptor {
  static final Map<int, NetworkData> _requests = <int, NetworkData>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final NetworkData networkData = NetworkData(
        url: options.uri.toString(),
        method: options.method,
        startTime: DateTime.now());
    _requests[options.hashCode] = networkData;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    final NetworkData? networkData = _map(response);
    _sendNetworkLog(networkData);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final NetworkData? networkData = _map(err.response!);
      _sendNetworkLog(networkData);
    }
    super.onError(err, handler);
  }

  NetworkData? _getRequestData(int requestHashCode) {
    if (_requests[requestHashCode] != null) {
      return _requests.remove(requestHashCode);
    }
    return null;
  }

  void _sendNetworkLog(NetworkData? networkData) {
    try {
      if (networkData != null) {
        NetworkLogger.networkLog(networkData);
      }
    } catch (_) {}
  }

  NetworkData? _map(Response<dynamic> response) {
    final NetworkData? networkDataRequest =
        _getRequestData(response.requestOptions.hashCode);
    if (networkDataRequest == null) {
      return null;
    }
    final Map<String, dynamic> responseHeaders = <String, dynamic>{};
    response.headers
        .forEach((String name, dynamic value) => responseHeaders[name] = value);
    return networkDataRequest.copyWith(
      endTime: DateTime.now(),
      duration: networkDataRequest.endTime != null
          ? networkDataRequest.endTime!.millisecondsSinceEpoch -
              networkDataRequest.startTime.millisecondsSinceEpoch
          : 0,
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      requestBody: response.requestOptions.data.toString(),
      requestHeaders: response.requestOptions.headers,
      contentType: response.requestOptions.contentType,
      status: response.statusCode,
      responseBody: response.data.toString(),
      responseHeaders: responseHeaders,
    );
  }
}
