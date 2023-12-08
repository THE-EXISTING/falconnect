import 'package:falconnect/lib.dart';

class BadGatewayException extends NetworkServerErrorException {
  const BadGatewayException({
    super.code = 502,
    super.message,
    super.developerMessage,
  });
}
