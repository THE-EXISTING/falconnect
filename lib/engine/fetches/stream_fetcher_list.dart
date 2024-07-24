import 'package:falconnect/lib.dart';

class EitherStreamFetcherList {
  final Map<dynamic, EitherStreamFetcher> _fetcherMap = {};

  Stream<WidgetEventState<T?>> fetchStream<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    bool debounceFetch = true,
  }) {
    _fetcherMap.removeWhere((key, value) => value.isClose);
    if (_canFetch(key, debounceFetch)) {
      final fetcher = EitherStreamFetcher<T>();
      _fetcherMap[key] = fetcher;
      return fetcher.fetch(call);
    } else {
      Log.w('Debounce fetch, use same stream !!!');
      return (_fetcherMap[key]! as EitherStreamFetcher<T>).stream;
    }
  }

  Stream<WidgetEventState<T?>> fetchFuture<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    bool debounceFetch = true,
  }) =>
      fetchStream<T>(
        key: key,
        call: Stream.fromFuture(call),
        debounceFetch: debounceFetch,
      );

  void _forceCloseFetcherByKey(dynamic key) {
    final fetcher = _fetcherMap[key];
    fetcher?.close();
  }

  bool _canFetch(Object key, bool debounceFetch) {
    if (debounceFetch) {
      return _fetcherMap[key] == null;
    } else {
      // Remove and close old fetcher before.
      final fetcher = _fetcherMap.remove(key);
      fetcher?.close();
      return true;
    }
  }

  void close() {
    _fetcherMap.forEach((key, fetcher) => fetcher.close());
  }
}