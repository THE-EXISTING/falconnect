import 'package:falconnect/lib.dart';

class FutureFetcherList {
  final Map<dynamic, FutureFetcher> _fetcherMap = {};

  Future<void> fetch<T>({
    required Object key,
    required Future<Either<Object, T>> call,
    required Function(WidgetDataState<T?> data) onFetch,
    Function(Object fail)? onFail,
    bool debounceFetch = true,
  }) async {
    _removeFetcherIfClose();

    if (!debounceFetch) await _forceCloseFetcherByKey(key);

    FutureFetcher<T>? fetcher = _fetcherMap[key] as FutureFetcher<T>?;

    if (fetcher != null && debounceFetch) return;
    if (fetcher == null) {
      fetcher = FutureFetcher<T>();
      _fetcherMap[key] = fetcher;
    }

    return fetcher.fetch(
      call,
      onFetch: onFetch,
      onFail: onFail,
    );
  }

  Future<void> _forceCloseFetcherByKey(dynamic key) async {
    final fetcher = _fetcherMap[key];
    await fetcher?.close();
  }

  void _removeFetcherIfClose() {
    _fetcherMap.removeWhere((key, value) => value.isClose);
  }

  void close() {
    _fetcherMap.forEach((key, fetcher) => fetcher.close());
  }
}
