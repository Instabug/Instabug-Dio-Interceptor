import 'package:dio/dio.dart';
import 'package:instabug/models/network_data.dart';
import 'package:instabug/NetworkLogger.dart';

class InstabugDioInterceptor extends Interceptor {

  static final Map<int, NetworkData> _requests = <int, NetworkData>{};

  @override
  dynamic onRequest(RequestOptions options) {
    final NetworkData data = NetworkData();
    data.startTime = DateTime.now();
    _requests[options.hashCode] = data;
  }

  @override
  dynamic onResponse(Response response) {
    NetworkLogger.networkLog(_map(response));
  }

  @override
  dynamic onError(DioError err) {
    NetworkLogger.networkLog(_map(err.response));
  }

  static NetworkData _getRequestData(int requestHashCode) {
    if (_requests[requestHashCode] != null) {
      return _requests.remove(requestHashCode);
    }
    return null;
  }

  NetworkData _map(Response response) {
    final NetworkData data = _getRequestData(response.request.hashCode);
    data.endTime = DateTime.now();
    data.duration = data.endTime.millisecondsSinceEpoch - data.startTime.millisecondsSinceEpoch;
    final Map<String, dynamic> responseHeaders = <String, dynamic>{};
    response.headers.forEach((name, value) => responseHeaders[name] = value);
    data.url = response.request.uri.toString();
    data.method = response.request.method;
    data.requestBody = response.request.data;
    data.requestHeaders = response.request.headers;
    data.contentType = response.request.contentType.toString();
    data.status = response.statusCode;
    data.responseBody = response.data;   
    data.responseHeaders = responseHeaders; 
    return data;
  }

}