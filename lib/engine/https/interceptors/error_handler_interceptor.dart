import 'package:falconnect/lib.dart';

abstract class NetworkErrorHandlerInterceptor extends InterceptorsWrapper {
  NetworkErrorHandlerInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (isError(response)) {
      final Exception? exception = getExceptionFromResponse(response);
      final error = DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: exception,
        stackTrace: Trace.current(),
        type: DioExceptionType.unknown,
        message: response.statusMessage,
      );
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
    } else if (isError(response)) {
      final Exception? exception = getExceptionFromResponse(err.response);
      handler.reject(
        err.copyWith(
          error: exception,
          stackTrace: Trace.current(),
        ),
      );
    } else {
      super.onError(err, handler);
    }
  }

  ///========================= PRIVATE METHOD =========================///
  bool isError(Response? response) =>
      response != null && (response.statusCode ?? 0) >= 400;

  Exception? getExceptionFromResponse(Response? response) {
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
      } else if (code == 501) {
        return NotImplementException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else if (code == 502) {
        return BadGatewayException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else if (code == 503) {
        return ServiceUnavailableException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else if (code == 504) {
        return GatewayTimeoutException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      } else {
        return NetworkServerErrorException(
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
        return ForbiddenException(
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
        return NetworkClientErrorException(
          code: code,
          message: errorMessage ?? response?.statusMessage,
          developerMessage: 'Http Interceptor',
        );
      }
    }
    return null;
  }
}
