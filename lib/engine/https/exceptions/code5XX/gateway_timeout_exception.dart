import 'package:falconnect/lib.dart';

class GatewayTimeoutException extends ServerErrorException {
  const GatewayTimeoutException({
    super.code = 504,
    super.message,
    super.developerMessage,
    super.errors,
    this.timeout,
  });

  final int? timeout;
}
