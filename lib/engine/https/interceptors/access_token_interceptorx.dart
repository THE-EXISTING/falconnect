import 'package:falconnect/falconnect.dart';
import 'package:flutter/foundation.dart';

abstract class TokenInterceptorX extends InterceptorsWrapper {
  TokenInterceptorX({required int retryAccessTokenLimit})
      : _retryAccessTokenLimit = retryAccessTokenLimit,
        retryAccessTokenLimitCounter = retryAccessTokenLimit;

  String? _accessToken;
  String? refreshToken;
  bool isUseToken = true;

  int get tokenErrorCode;

  final int _retryAccessTokenLimit;
  int retryAccessTokenLimitCounter;

  set accessToken(String? value) {
    _accessToken = value;
  }

  bool get hasAccessToken =>
      _accessToken != null && _accessToken?.isNotEmpty == true;

  bool get hasRefreshToken =>
      refreshToken != null && refreshToken?.isNotEmpty == true;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (hasAccessToken && isUseToken) {
      options.setHeaderTokenBearer(_accessToken!);
    } else {
      options.removeHeaderToken();
    }
    super.onRequest(options, handler);
  }

  @protected
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == tokenErrorCode) {
      onHandleTokenResponse(response, handler);
    } else {
      retryAccessTokenLimitCounter = _retryAccessTokenLimit;
      super.onResponse(response, handler);
    }
  }

  @protected
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == tokenErrorCode) {
      onHandleTokenError(err, handler);
    } else {
      super.onError(err, handler);
    }
  }

  void onHandleTokenResponse(
      Response response, ResponseInterceptorHandler handler);

  void onHandleTokenError(DioError err, ErrorInterceptorHandler handler);
}
