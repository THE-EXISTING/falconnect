import 'package:falconnect/lib.dart';

class EitherFetcher<T> {
  EitherFetcher([StreamController<WidgetState<T?>>? controller])
      : _streamController = controller ?? StreamController<WidgetState<T?>>();

  StreamSubscriptionWrapper? subscription;
  int _count = 0;

  bool get isClose => _streamController.isClosed;

  final StreamController<WidgetState<T?>> _streamController;

  Stream<WidgetState<T?>> get stream => _streamController.stream;

  Stream<WidgetState<T?>> fetch(Stream<Either<Failure, T>> call,) {
    return call.transform(
        StreamTransformer<Either<Failure, T>, WidgetState<T?>>.fromHandlers(
          handleData: (Either<Failure, T> data,
              EventSink<WidgetState<T?>> sink) {
            if (_count == 0) {
              sink.add(WidgetState(WidgetStatus.loading, data: null));
              _count++;
            }
            data.fold(
                  (failure) => throw failure,
                  (T data) =>
                  sink.add(WidgetState(WidgetStatus.success, data: data)),
            );
          },
          handleDone: (sink) {
            Log.success('Fetch onDone');
            _streamController.close();
          },
          // handleError: (error, stackTrace, sink) {
          //   rethrow error, stackTrace;
          // },
        ));
  }

  void close() {
    _streamController.close();
    subscription?.cancel();
  }
}
