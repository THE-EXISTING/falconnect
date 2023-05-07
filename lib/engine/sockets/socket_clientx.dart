import 'dart:async';
import 'package:falconnect/falconnect.dart';
import 'package:falconnect/utils/nlog.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

abstract class SocketClientX implements RequestSocketService {
  static const TAG = 'SocketChannel';
  late SocketOptions _tmpOptions;
  late PublishSubject<SocketResponseX> _replaySubject;
  late int _retryLimitCounter;
  late final SocketInterceptors interceptors;

  WebSocketChannel? _channel;
  bool _isClose = true;
  StreamSubscription? _subscription;

  bool get isClose => _isClose;

  set setIsClose(bool isClose) => _isClose = isClose;

  SocketOptions get options => _tmpOptions;

  SocketClientX(String baseUrl) {
    _tmpOptions = SocketOptions();
    _tmpOptions.uri = baseUrl;
    _replaySubject = PublishSubject<SocketResponseX>();
    _retryLimitCounter = _tmpOptions.retryLimit;
    interceptors = SocketInterceptors();
    setupConfig(_tmpOptions);
    setupInterceptors(interceptors);
  }

  void setupConfig(SocketOptions configs);

  void setupInterceptors(SocketInterceptors interceptors) {}

  @override
  Future<void> createChannel() async {
    if (_channel != null || !_isClose) {
      await closeChannel();
      _isClose = true;
    }

    _channel = WebSocketChannel.connect(Uri.parse(_tmpOptions.uri));
    _subscription = _channel?.stream.listen(
      _onResponse,
      onError: _onError,
      onDone: _onDone,
    );
    //mai Naaaaaaaaa
    _isClose = false;
  }

  Future<void> _onDone() async {
    NLog.i(TAG, 'DONE');
    _logCloseReason();
    await closeChannel();
  }

  void _onError(error, stackTrace) async {
    if (_retryLimitCounter > 0) {
      _executeInterceptorOnError(
          exception: SocketRetryException(
            retryCount: _retryLimitCounter,
            exception: error,
            stackTrace: stackTrace,
          ),
          options: _tmpOptions.copyWith());
      _isClose = false;
      _retryLimitCounter--;
      if (_tmpOptions.data != null) {
        _channel?.sink.add(_tmpOptions.data);
      }
    } else {
      _executeInterceptorOnError(
          exception: SocketException(
            exception: error,
            stackTrace: stackTrace,
          ),
          options: _tmpOptions.copyWith());
      _isClose = true;
      _replaySubject.addError(error, stackTrace);
      _subscription?.cancel();
    }
  }

  @override
  Future<void> closeChannel() async {
    if (_isClose == false) {
      await _channel?.sink.close();
      await _subscription?.cancel();
      _isClose = true;
      _tmpOptions = _tmpOptions.copyWith(data: null);
    }
  }

  /// Create channel automatically when first call request.
  @override
  void request(String data) async {
    if (_channel == null || isClose == true) {
      await createChannel();
    }
    _tmpOptions = _tmpOptions.copyWith(
      protocol: _channel?.protocol,
      data: data,
    );
    _executeInterceptorOnRequest(options: _tmpOptions);
    _channel?.sink.add(_tmpOptions.data);
  }

  @override
  Stream<T> getResponseStream<T>({
    bool Function(SocketResponseX response)? filter,
    required T Function(SocketResponseX response) converter,
  }) =>
      _replaySubject.stream
          .where(filter ?? (data) => true)
          .asyncMap((response) => converter(response));

  @override
  Stream<SocketResponseX> getRawStream({
    bool Function(SocketResponseX response)? filter,
  }) =>
      _replaySubject.stream.where(filter ?? (data) => true);

  Future<void> checkConnection() async {
    try {
      Log.i('Socket: PING to server');
      _channel?.sink.add('ping');
    } on StateError catch (error, stackTrace) {
      Log.e(error, stackTrace);
      await createChannel();
    }
  }

  void _onResponse(response) {
    _retryLimitCounter = _tmpOptions.retryLimit;
    final responseWrap = SocketResponseX(
      data: response,
      requestOptions: _tmpOptions.copyWith(),
    );
    _executeInterceptorOnResponse(response: responseWrap);
    _replaySubject.add(responseWrap);
  }

  void _executeInterceptorOnRequest({
    required SocketOptions options,
  }) {
    for (var interceptor in interceptors) {
      interceptor.onRequest(options);
    }
  }

  void _executeInterceptorOnResponse({
    required SocketResponseX response,
  }) {
    for (var interceptor in interceptors) {
      interceptor.onResponse(response);
    }
  }

  void _executeInterceptorOnError({
    required SocketException exception,
    required SocketOptions options,
  }) {
    for (var interceptor in interceptors) {
      interceptor.onError(exception, options);
    }
  }

  void _logCloseReason() {
    final protocol = _channel?.protocol;
    final closeCode = _channel?.closeCode;
    final closeReason = _channel?.closeReason;
    Log.w('Protocol: $protocol\nClose code: $closeCode\nClose reason: $closeReason');
  }
}
