import 'package:falconnect/lib.dart';

class EitherFetcher<T> {
  EitherFetcher([StreamController<WidgetState<T?>>? controller])
      : _streamController = controller ?? StreamController<WidgetState<T?>>();

  StreamSubscriptionWrapper? subscription;

  // bool get isClose => subscription?.isClosed ?? true;
  bool get isClose => _streamController.isClosed;

  final StreamController<WidgetState<T?>> _streamController;

  Stream<WidgetState<T?>> get stream => _streamController.stream;

  Stream<WidgetState<T?>> fetch(
    Stream<Either<Failure, T>> call,
    // {
    // required Function(WidgetState<T?> data) onFetch,
    // Function(Failure failure)? onFail,
    // }
  ) {
    // onFetch(WidgetState(WidgetStatus.loading, data: null));
    _streamController.add(WidgetState(WidgetStatus.loading, data: null));
    _streamController.addStream(call.transform(
        StreamTransformer<Either<Failure, T>, WidgetState<T>>.fromHandlers(
      handleData: (Either<Failure, T> data, EventSink<WidgetState<T>> sink) {
        data.fold(
          (failure) => throw failure,
          (T data) => sink.add(WidgetState(WidgetStatus.success, data: data)),
        );
      },
      handleDone: (sink) {
        Log.success('Fetch onDone');
        _streamController.close();
      },
      handleError: (error, stackTrace, sink) {
        throw Failure.fromException(exception: error, stacktrace: stackTrace);
      },
    )));
    return _streamController.stream;

    // if (subscription != null) {
    //   subscription?.cancel();
    // }
    // subscription = StreamSubscriptionWrapper<Either<Failure, T>>(
    //   call,
    //   onData: (Either<Failure, T> data) {
    //     data.fold(
    //       (Failure fail) => onFail?.call(fail),
    //       (T data) => onFetch(WidgetState(WidgetStatus.success, data: data)),
    //     );
    //   },
    //   onError: (error, stacktrace) {
    //     if (onFail == null) Log.e(error, stacktrace);
    //     onFail?.call(Failure.fromException(
    //       exception: error,
    //       stacktrace: stacktrace,
    //     ));
    //   },
    //   onDone: () {
    //     Log.success('Fetch onDone');
    //   },
    // );
  }

  void close() {
    _streamController.close();
    subscription?.cancel();
  }
}
