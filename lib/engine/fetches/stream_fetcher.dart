import 'package:falconnect/lib.dart';

class EitherStreamFetcher<T> {
  EitherStreamFetcher([StreamController<WidgetEventState<T?>>? controller])
      : _streamController = controller ?? StreamController<WidgetEventState<T?>>();

  final StreamController<WidgetEventState<T?>> _streamController;
  StreamSubscription? _streamSubscription;

  Stream<WidgetEventState<T?>> get stream => _streamController.stream;

  bool get isClose => _streamController.isClosed;

  Stream<WidgetEventState<T?>> fetch(
    Stream<Either<Failure, T>> call,
  ) {
    _streamController.add(WidgetEventState(WidgetStatus.loading, data: null));
    _streamSubscription = call.listen(
      (data) {
        data.fold(
          (failure) {
            _streamController.addError(failure);
            close();
          },
          (T data) {
            _streamController
                .add(WidgetEventState(WidgetStatus.success, data: data));
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
