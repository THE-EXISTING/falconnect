import 'package:falconnect/lib.dart';

abstract class NetworkErrorHandlerInterceptor extends InterceptorsWrapper {
  NetworkErrorHandlerInterceptor({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final result = await _connectivity.checkConnectivity();
    if (_isNoConnectedInternet(result)) {
      handler.reject(
        DioException(
            requestOptions: options,
            error: NoInternetConnectionException(service: options.path),
            stackTrace: Trace.current(),
            type: DioExceptionType.connectionError,
            message: 'No internet connection.'),
      );
    } else {
      super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isError(response)) {
      final Exception? exception = _getExceptionFromResponse(response);
      if (exception != null) {
        final error = DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: exception,
            stackTrace: Trace.current(),
            type: DioExceptionType.badResponse,
            message: response.statusMessage);
        handler.reject(error);
      } else {
        super.onResponse(response, handler);
      }
    } else {
      super.onResponse(response, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      final int timeout =
          err.requestOptions.connectTimeout?.inMilliseconds ?? -1;
      handler.reject(err.copyWith(
        error: NetworkTimeoutException(
            service: 'Http Interceptor', timeout: timeout),
        stackTrace: Trace.current(),
      ));
    } else if (response != null && _isError(response)) {
      final Exception? exception = _getExceptionFromResponse(err.response);
      if (exception != null) {
        handler.reject(err.copyWith(
          error: exception,
          stackTrace: Trace.current(),
          type: DioExceptionType.badResponse,
        ));
      } else {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  ///========================= PRIVATE METHOD =========================///

  bool _isError(Response? response) =>
      response != null && (response.statusCode ?? 0) >= 300;

  Exception? _getExceptionFromResponse(Response? response) {
    final code = response?.statusCode ?? 0;
    String? errorMessage;
    if (response?.data is String) {
      errorMessage = response?.data;
    } else if (response?.data is Map) {
      errorMessage = response?.data['error'];
    }
    if (code >= 500) {
      return InternalErrorException(
        service: 'Http Interceptor',
        code: code,
        message: errorMessage ?? response?.statusMessage,
      );
    } else if (code >= 400) {
      if (code == 400) {
        return BadRequestException(
          service: 'Http Interceptor',
          message: errorMessage ?? response?.statusMessage,
        );
      } else if (code == 404) {
        return NotFoundException(
          service: 'Http Interceptor',
          code: code,
          message: errorMessage ?? response?.statusMessage,
        );
      }
    }
    return null;
  }

  bool _isNoConnectedInternet(ConnectivityResult result) {
    return result != ConnectivityResult.wifi &&
        result != ConnectivityResult.ethernet &&
        result != ConnectivityResult.mobile &&
        result != ConnectivityResult.vpn;
  }
}
