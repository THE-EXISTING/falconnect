import 'package:falconnect/lib.dart';

class FetcherList {
  final Map<dynamic, EitherFetcher> _fetcherMap = {};

  Future<void> fetchStream<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    required Function(WidgetState<T?> data) onFetch,
    Function(Failure failure)? onFail,
    bool debounceFetch = true,
  }) async {
    _removeFetcherIfClose();

    if (!debounceFetch) await _forceCloseFetcherByKey(key);

    EitherFetcher<T>? fetcher = _fetcherMap[key] as EitherFetcher<T>?;

    if (fetcher != null && debounceFetch) return;
    if (fetcher == null) {
      fetcher = EitherFetcher<T>();
      _fetcherMap[key] = fetcher;
    }

    return fetcher.fetch(
      call,
      onFetch: onFetch,
      onFail: onFail,
    );
  }

  Future<void> fetchFuture<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    required Function(WidgetState<T?> data) onFetch,
    Function(Failure failure)? onFail,
    bool debounceFetch = true,
  }) =>
      fetchStream<T>(
        key: key,
        call: Stream.fromFuture(call),
        onFetch: onFetch,
        onFail: onFail,
        debounceFetch: debounceFetch,
      );

  Future<void> _forceCloseFetcherByKey(dynamic key) async {
    final fetcher = _fetcherMap[key];
    fetcher?.close();
  }

  void _removeFetcherIfClose() {
    _fetcherMap.removeWhere((key, value) => value.isClose);
  }

  void close() {
    _fetcherMap.forEach((key, fetcher) => fetcher.close());
  }
}
