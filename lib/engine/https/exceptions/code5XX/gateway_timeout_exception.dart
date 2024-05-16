import 'package:falconnect/lib.dart';

class GatewayTimeoutException extends NetworkServerErrorException {
  const GatewayTimeoutException({
    super.code = 504,
    super.message,
    super.developerMessage,
  });
}
