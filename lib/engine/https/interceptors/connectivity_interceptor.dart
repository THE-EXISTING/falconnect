import 'package:falconnect/lib.dart';

class ConnectivityInterceptor extends InterceptorsWrapper {
  ConnectivityInterceptor({Connectivity? connectivity})
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

  ///========================= PRIVATE METHOD =========================///
  bool _isNoConnectedInternet(ConnectivityResult result) {
    return result != ConnectivityResult.wifi &&
        result != ConnectivityResult.ethernet &&
        result != ConnectivityResult.mobile &&
        result != ConnectivityResult.vpn;
  }
}
