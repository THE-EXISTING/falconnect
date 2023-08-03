import 'package:falconnect/lib.dart';
import 'package:flutter/foundation.dart';

abstract class AccessTokenInterceptor extends InterceptorsWrapper {
  AccessTokenInterceptor({required this.retryAccessTokenLimit})
      : retryCounter = 0;

  String? accessToken;
  String? refreshToken;
  final int retryAccessTokenLimit;
  int retryCounter;

  // bool isUseToken = true;

  int get tokenErrorCode;

  bool get hasAccessToken =>
      accessToken != null && accessToken?.isNotEmpty == true;

  bool get hasRefreshToken =>
      refreshToken != null && refreshToken?.isNotEmpty == true;

  // @override
  // void onRequest(
  //     RequestOptions options, RequestInterceptorHandler handler) async {
  //   if (hasAccessToken && isUseToken) {
  //     options.setHeaderTokenBearer(accessToken!);
  //   } else {
  //     options.removeHeaderToken();
  //   }
  //   super.onRequest(options, handler);
  // }

  @protected
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == tokenErrorCode) {
      onHandleTokenResponse(response, handler);
    } else {
      retryCounter = 0;
      super.onResponse(response, handler);
    }
  }

  @protected
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == tokenErrorCode) {
      onHandleTokenError(err, handler);
    } else {
      retryCounter = 0;
      super.onError(err, handler);
    }
  }

  void onHandleTokenResponse(
      Response response, ResponseInterceptorHandler handler);

  void onHandleTokenError(DioException err, ErrorInterceptorHandler handler);
}
