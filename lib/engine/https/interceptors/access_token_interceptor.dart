import 'package:falconnect/lib.dart';
import 'package:flutter/foundation.dart';

abstract class AccessTokenInterceptor extends InterceptorsWrapper {
  AccessTokenInterceptor({required int retryAccessTokenLimit})
      : _retryAccessTokenLimit = retryAccessTokenLimit,
        _retryAccessTokenCounter = retryAccessTokenLimit;

  String? _accessToken;
  String? refreshToken;
  bool isUseToken = true;

  int get tokenErrorCode;

  final int _retryAccessTokenLimit;
  int _retryAccessTokenCounter;

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
      _retryAccessTokenCounter = _retryAccessTokenLimit;
      super.onResponse(response, handler);
    }
  }

  @protected
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == tokenErrorCode) {
      onHandleTokenError(err, handler);
    } else {
      super.onError(err, handler);
    }
  }

  void onHandleTokenResponse(
      Response response, ResponseInterceptorHandler handler);

  void onHandleTokenError(DioException err, ErrorInterceptorHandler handler);
}
