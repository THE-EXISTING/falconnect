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
  bool _isNoConnectedInternet(List<ConnectivityResult> result) {
    return !result.contains(ConnectivityResult.wifi) &&
        !result.contains(ConnectivityResult.ethernet) &&
        !result.contains(ConnectivityResult.mobile) &&
        !result.contains(ConnectivityResult.vpn);
  }
}
