import 'package:falconnect/lib.dart';

class FutureFetcher<T> {
  bool get isClose => _isClose;

  bool _isClose = true;

  Future<void> fetch(
    Future<Either<Object, T>> call, {
    required Function(WidgetDataState<T?> data) onFetch,
    Function(Object fail)? onFail,
  }) async {
    _isClose = false;
    onFetch(WidgetDataState(WidgetDisplayState.loading, null));
    try {
      await call.then(
        (data) => data.fold(
          (Object fail) => onFail?.call(fail),
          (T data) =>
              onFetch(WidgetDataState(WidgetDisplayState.success, data)),
        ),
      );
    } catch (exception) {
      onFail?.call(exception);
    }
    _isClose = true;
  }

  Future<void> close() async {
    _isClose = true;
  }
}
