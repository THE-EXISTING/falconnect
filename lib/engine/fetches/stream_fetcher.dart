import 'package:falconnect/lib.dart';

class EitherStreamFetcher<T> {
  EitherStreamFetcher([StreamController<WidgetEventState<T?>>? controller])
      : _streamController =
            controller ?? StreamController<WidgetEventState<T?>>();

  final StreamController<WidgetEventState<T?>> _streamController;
  StreamSubscription? _streamSubscription;

  Stream<WidgetEventState<T?>> get stream => _streamController.stream;

  bool get isClose => _streamController.isClosed;

  T? _data;

  Stream<WidgetEventState<T?>> fetch(
    Stream<Either<Failure, T>> call,
  ) {
    _streamController
        .add(WidgetEventState(FullWidgetState.loading, data: _data));
    _streamSubscription = call.listen(
      (data) {
        data.fold(
          (failure) {
            _streamController.addError(failure);
            close();
          },
          (T data) {
            _data = data;
            _streamController
                .add(WidgetEventState(FullWidgetState.success, data: _data));
          },
        );
      },
      onDone: () {
        Log.success('Fetch: onDone called');
        close();
      },
      onError: (error, stackTrace) {
        _streamController.addError(error, stackTrace);
        close();
      },
    );
    return _streamController.stream;
  }

  void close() {
    _streamSubscription?.cancel();
    _streamController.close();
  }
}
