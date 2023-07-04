import 'package:falconnect/lib.dart';

class Fetcher<T extends BlocState> {
  StreamSubscriptionWrapper? subscription;

  bool get isClose => subscription?.isClosed ?? true;

  Future<void> fetch(
    Stream<T> call, {
    required Function(T data) onFetch,
    Function? onFail,
  }) async {
    if (subscription != null) {
      subscription?.cancel();
    }
    subscription = StreamSubscriptionWrapper<T>(
      call,
      onData: (T data) {
        onFetch(data);
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
