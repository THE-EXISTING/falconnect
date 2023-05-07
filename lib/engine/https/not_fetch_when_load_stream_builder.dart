import 'dart:async';
import 'package:falconnect/falconnect.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

class NotFetchWhenLoadingStreamBuilder<T> {
  BlocStatus? _status;
  StreamSubscription? subscription;

  final _subject = PublishSubject<BlocState<T>>();

  Stream<BlocState<T>> call({required Stream<BlocState<T>> Function() fetch}) {
    if (_status != BlocStatus.loading) {
      if (subscription != null) {
        subscription?.cancel();
      }
      subscription = fetch().listen((BlocState<T> data) {
        _status = data.status;
        if (_status == BlocStatus.error || _status == BlocStatus.success) {
          subscription?.cancel();
        }
        _subject.add(data);
      }, onError: (error,stackTrace) {
        _subject.add(BlocState.exception(error: error,stackTrace:stackTrace));
        subscription?.cancel();
      }, onDone: () {
        subscription?.cancel();
      });
    }
    return _subject.stream;
  }
}
