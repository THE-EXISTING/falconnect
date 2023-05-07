import 'package:falconnect/falconnect.dart';
import 'package:falmodel/falmodel.dart';

abstract class RequestApiService {
  Future<Response<T>> get<T>(
    String endPoint, {
    Map<String, Object>? queryParameters,
    Options? options,
    bool isUseToken = true,
    required T Function(Map<String, dynamic> json) converter,
    T? Function(DioError exception, StackTrace? stackTrace)? catchError,
  });

  Future<Response<T>> post<T>(
    String endPoint, {
    RequestBodyX? data,
    Options? options,
    bool isUseToken = true,
    Map<String, Object>? queryParameters,
    required T Function(Map<String, dynamic> json) converter,
    T? Function(DioError exception, StackTrace? stackTrace)? catchError,
  });

  Future<Response<T>> postFormData<T>(
    String endPoint, {
    FormData? data,
    Options? options,
    bool isUseToken = true,
    required T Function(Map<String, dynamic> json) converter,
    T? Function(DioError exception, StackTrace? stackTrace)? catchError,
  });

  Future<Response<T>> put<T>(
    String endPoint, {
    RequestBodyX? data,
    Options? options,
    bool isUseToken = true,
    required T Function(Map<String, dynamic> json) converter,
    T? Function(DioError exception, StackTrace? stackTrace)? catchError,
  });

  Future<Response<T>> putFormData<T>(
    String endPoint, {
    FormData? data,
    Options? options,
    bool isUseToken = true,
    required T Function(Map<String, dynamic> json) converter,
    T? Function(DioError exception, StackTrace? stackTrace)? catchError,
  });

  Future<Response<T>> delete<T>(
    String endPoint, {
    RequestBodyX? data,
    Map<String, Object>? queryParameters,
    Options? options,
    bool isUseToken = true,
    required T Function(Map<String, dynamic> json) converter,
    T? Function(DioError exception, StackTrace? stackTrace)? catchError,
  });
}
