// ignore_for_file: constant_identifier_names

import 'package:falconnect/lib.dart';

class CacheInterceptor extends Interceptor {
  static const TAG = 'CacheInterceptor';

  CacheInterceptor();

  final _cache = <Uri, Response>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var response = _cache[options.uri];
    if (options.extra['refresh'] == true) {
      NLog.i(TAG, '${options.uri}: force refresh, ignore cache! \n');
      return handler.next(options);
    } else if (response != null) {
      NLog.i(TAG, 'cache hit: ${options.uri} \n');
      return handler.resolve(response);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    NLog.e(TAG, 'onError: $err', err);
    super.onError(err, handler);
  }
}
