import 'dart:collection';
import 'package:falconnect/falconnect.dart';
import 'package:falmodel/falmodel.dart';

class SocketInterceptors extends ListMixin<SocketInterceptor> {
  final _list = <SocketInterceptor>[];

  @override
  int length = 0;

  @override
  SocketInterceptor operator [](int index) {
    return _list[index];
  }

  @override
  void operator []=(int index, value) {
    if (_list.length == index) {
      _list.add(value);
    } else {
      _list[index] = value;
    }
  }
}

abstract class SocketInterceptor {
  //TODO: Implement interceptor followed dio concept

  void onRequest(SocketOptions options);

  void onResponse(SocketResponseX response);

  void onError(SocketException err, SocketOptions options);
}
