import 'package:falconnect/lib.dart';

class EitherStreamFetcher<T> {
  EitherStreamFetcher([StreamController<WidgetStateEvent<T?>>? controller])
      : _streamController =
            controller ?? StreamController<WidgetStateEvent<T?>>();

  final StreamController<WidgetStateEvent<T?>> _streamController;
  StreamSubscription? _streamSubscription;

  Stream<WidgetStateEvent<T?>> get stream => _streamController.stream;

  bool get isClose => _streamController.isClosed;

  T? _data;

  Stream<WidgetStateEvent<T?>> fetch(
    Stream<Either<Failure, T>> call,
  ) {
    _streamController
        .add(WidgetStateEvent(FullWidgetState.loading, data: _data));
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
                .add(WidgetStateEvent(FullWidgetState.success, data: _data));
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

  Future<void> close() async {
    await _streamSubscription?.cancel();
    await _streamController.close();
  }
}
