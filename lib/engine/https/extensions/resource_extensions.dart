import 'package:falconnect/falconnect.dart';
import 'package:falmodel/falmodel.dart';

extension FutureResource<T> on Future<T?> {
  Future<BlocState<T>> mapToSuccessResource() async {
    return then((data) => BlocState.success<T>(data: data));
  }
}

extension StreamResource<T> on Stream<T?> {
  Stream<BlocState<T>> mapToSuccessResource() {
    return map((data) => BlocState.success<T>(data: data));
  }
}
