import 'package:falconnect/lib.dart';

class EitherFetcher<T> {
  StreamSubscriptionWrapper? subscription;

  bool get isClose => subscription?.isClosed ?? true;

  Future<void> fetch(
    Stream<Either<Failure, T>> call, {
    required Function(WidgetState<T?> data) onFetch,
    Function(Failure failure)? onFail,
  }) async {
    onFetch(WidgetState(WidgetStatus.loading, data: null));

    if (subscription != null) {
      subscription?.cancel();
    }
    subscription = StreamSubscriptionWrapper<Either<Failure, T>>(
      call,
      onData: (Either<Failure, T> data) {
        data.fold(
          (Failure fail) => onFail?.call(fail),
          (T data) => onFetch(WidgetState(WidgetStatus.success, data: data)),
        );
      },
      onError: (error, stacktrace) {
        if (onFail == null) Log.e(error, stacktrace);
        onFail?.call(Failure.fromException(
          exception: error,
          stacktrace: stacktrace,
        ));
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
