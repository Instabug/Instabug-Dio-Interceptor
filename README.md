# Instabug Dio Interceptor

This package is an add on to [Instabug-Flutter](https://github.com/Instabug/Instabug-Flutter).

It intercepts any requests performed with `Dio` Package and sends them to the report that will be sent to the dashboard.  

## Integration

To enable network logging, simply add the  `InstabugDioInterceptor` to the dio object interceptors as follows:

```dart
var dio = new Dio();
dio.interceptors.add(InstabugNetworkInterceptor());
```
