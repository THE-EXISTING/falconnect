import 'package:falconnect/lib.dart';

class EitherFetcher<T> {
  StreamSubscriptionWrapper? subscription;

  bool get isClose => subscription?.isClosed ?? true;

  Future<void> fetch(
    Stream<Either<Object, T>> call, {
    required Function(WidgetState<T?> data) onFetch,
    Function(Object failure)? onFail,
  }) async {
    onFetch(WidgetState(WidgetStatus.loading, data: null));

    if (subscription != null) {
      subscription?.cancel();
    }
    subscription = StreamSubscriptionWrapper<Either<Object, T>>(
      call,
      onData: (Either<Object, T> data) {
        data.fold(
          (Object fail) => onFail?.call(fail),
          (T data) => onFetch(WidgetState(WidgetStatus.success, data: data)),
        );
      },
      onError: onFail ??
          (error, stacktrace) {
            Log.e(error, stacktrace);
          },
      onDone: () {
        Log.success('Fetch onDone');
      },
    );
  }

  void close() {
    subscription?.cancel();
  }
}
