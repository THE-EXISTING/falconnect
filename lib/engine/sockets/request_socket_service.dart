import 'package:falconnect/lib.dart';
import 'package:faltool/faltool.dart';

abstract class RequestSocketService {
  void createChannel();

  void request(String body);

  Future<void> closeChannel();

  Stream<T> getResponseStream<T>({
    required bool Function(SocketResponse response) filter,
    required T Function(SocketResponse response) converter,
  });

  Stream<SocketResponse> getRawStream({
    bool Function(SocketResponse response)? filter,
  });
}
