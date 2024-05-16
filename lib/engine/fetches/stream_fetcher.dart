import 'package:falconnect/lib.dart';

class EitherStreamFetcher<T> {
  EitherStreamFetcher([StreamController<WidgetState<T?>>? controller])
      : _streamController = controller ?? StreamController<WidgetState<T?>>();

  final StreamController<WidgetState<T?>> _streamController;
  StreamSubscription? _streamSubscription;

  Stream<WidgetState<T?>> get stream => _streamController.stream;

  bool get isClose => _streamController.isClosed;

  Stream<WidgetState<T?>> fetch(
    Stream<Either<Failure, T>> call,
  ) {
    _streamController.add(WidgetState(WidgetStatus.loading, data: null));
    _streamSubscription = call.listen(
      (data) {
        data.fold(
          (failure) {
            _streamController.addError(failure);
            close();
          },
          (T data) {
            _streamController
                .add(WidgetState(WidgetStatus.success, data: data));
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
