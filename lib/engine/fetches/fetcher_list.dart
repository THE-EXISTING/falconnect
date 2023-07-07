import 'package:falconnect/lib.dart';

class FetcherList {
  final Map<dynamic, EitherFetcher> _fetcherMap = {};

  Stream<WidgetState<T?>> fetchStream<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    // required Function(WidgetState<T?> data) onFetch,
    // Function(Failure failure)? onFail,
    bool debounceFetch = true,
  }) {
    if (_canFetch(key, debounceFetch)) {
      final fetcher = EitherFetcher<T>();
      _fetcherMap[key] = fetcher;
      return fetcher.fetch(call);
    } else {
      Log.w('Debounce fetch use same stream !!!');
      return (_fetcherMap[key]! as EitherFetcher<T>).stream;
    }

    // if (!debounceFetch) _forceCloseFetcherByKey(key);
    //
    // EitherFetcher<T>? fetcher = _fetcherMap[key] as EitherFetcher<T>?;
    //
    // if (fetcher != null && debounceFetch) return;
    // if (fetcher == null) {
    //   fetcher = EitherFetcher<T>();
    //   _fetcherMap[key] = fetcher;
    // }
    //
    // return fetcher.fetch(
    //   call,
    //   // onFetch: onFetch,
    //   // onFail: onFail,
    // );
  }

  Stream<WidgetState<T?>> fetchFuture<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    // required Function(WidgetState<T?> data) onFetch,
    // Function(Failure failure)? onFail,
    bool debounceFetch = true,
  }) =>
      fetchStream<T>(
        key: key,
        call: Stream.fromFuture(call),
        // onFetch: onFetch,
        // onFail: onFail,
        debounceFetch: debounceFetch,
      );

  void _forceCloseFetcherByKey(dynamic key) {
    final fetcher = _fetcherMap[key];
    fetcher?.close();
  }

  bool _canFetch(Object key, bool debounceFetch) {
    _fetcherMap.removeWhere((key, value) => value.isClose);
    if (debounceFetch) {
      return _fetcherMap[key] == null;
    } else {
      final fetcher = _fetcherMap.remove(key);
      fetcher?.close();
      return true;
    }
  }

  void close() {
    _fetcherMap.forEach((key, fetcher) => fetcher.close());
  }
}
