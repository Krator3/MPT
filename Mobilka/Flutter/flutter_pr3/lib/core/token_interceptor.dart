import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor({required this.token});

  final String token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Api-Key'] = token;
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }
}
