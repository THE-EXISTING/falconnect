import 'package:falconnect/falconnect.dart';

class NetworkTimeoutException extends Network4XXException {
  const NetworkTimeoutException({
    required String service,
    int code = 408,
    int? timeout,
    String? message,
  }) : super(
            service: service,
            code: code,
            message: message ?? 'Connecting timed out. [$timeout]');
}
