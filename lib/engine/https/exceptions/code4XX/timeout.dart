import 'package:falconnect/lib.dart';

class NetworkTimeoutException extends Network4XXException {
  const NetworkTimeoutException({
    super.code = 408,
    super.developerMessage,
    int? timeout,
    String? message,
  }) : super(message: message ?? 'Connecting timed out. [$timeout]');
}
