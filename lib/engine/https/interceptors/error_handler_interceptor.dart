import 'package:falconnect/lib.dart';

abstract class NetworkErrorHandlerInterceptor extends InterceptorsWrapper {
  NetworkErrorHandlerInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isError(response)) {
      final Exception? exception = _getExceptionFromResponse(response);
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
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      final int timeout =
          err.requestOptions.connectTimeout?.inMilliseconds ?? -1;
      handler.reject(
        err.copyWith(
          error: NetworkTimeoutException(
            timeout: timeout,
            developerMessage: 'Http Interceptor',
          ),
          stackTrace: Trace.current(),
        ),
      );
    } else if (response != null && _isError(response)) {
      final Exception? exception = _getExceptionFromResponse(err.response);
      handler.reject(
        err.copyWith(
          error: exception,
          stackTrace: Trace.current(),
          type: DioExceptionType.badResponse,
        ),
      );
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
      if (code == 500) {
        return InternalErrorException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else {
        return Network5XXException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      }
    } else if (code >= 400) {
      if (code == 400) {
        return BadRequestException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else if (code == 401) {
        return SessionExpiredException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else if (code == 403) {
        return AuthorizedNotFoundException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else if (code == 404) {
        return NotFoundException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else {
        return Network4XXException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      }
    }
    return null;
  }
}
