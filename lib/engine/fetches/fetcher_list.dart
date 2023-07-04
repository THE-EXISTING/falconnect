import 'package:falconnect/lib.dart';

class FetcherList {
  final Map<dynamic, Fetcher> _fetcherMap = {};

  Future<void> fetch<T extends BlocState>({
    required Object key,
    required Stream<T> call,
    required Function(T data) onFetch,
    Function? onFail,
    bool debounceFetch = true,
  }) async {
    _removeFetcherIfClose();

    if (!debounceFetch) await _forceCloseFetcherByKey(key);

    Fetcher<T>? fetcher = _fetcherMap[key] as Fetcher<T>?;

    if (fetcher != null && debounceFetch) return;
    if (fetcher == null) {
      fetcher = Fetcher<T>();
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
    fetcher?.close();
  }

  void _removeFetcherIfClose() {
    _fetcherMap.removeWhere((key, value) => value.isClose);
  }

  void close() {
    _fetcherMap.forEach((key, fetcher) => fetcher.close());
  }
}
