import 'package:falconnect/lib.dart';

class StreamSubscriptionWrapper<T> {
  StreamSubscriptionWrapper(
    Stream<T> stream, {
    required void Function(T) onData,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    _subscription = stream.listen(
      onData,
      onError: (error, stacktrace) {
        onError?.call(error, stacktrace);
        _isClosed = true;
      },
      onDone: () {
        onDone?.call();
        _isClosed = true;
      },
    );
  }

  late StreamSubscription<T> _subscription;
  bool _isClosed = false;

  bool get isClosed => _isClosed;

  void cancel() {
    _subscription.cancel();
  }
}
