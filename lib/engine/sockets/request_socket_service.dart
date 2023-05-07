import 'package:falconnect/falconnect.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

abstract class RequestSocketService {
  void createChannel();

  void request(String body);

  Future<void> closeChannel();

  Stream<T> getResponseStream<T>({
    required bool Function(SocketResponseX response) filter,
    required T Function(SocketResponseX response) converter,
  });

  Stream<SocketResponseX> getRawStream({
    bool Function(SocketResponseX response)? filter,
  });
}
