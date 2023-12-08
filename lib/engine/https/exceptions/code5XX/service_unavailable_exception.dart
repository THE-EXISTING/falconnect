import 'package:falconnect/lib.dart';

class ServiceUnavailableException extends NetworkServerErrorException {
  const ServiceUnavailableException({
    super.code = 503,
    super.message,
    super.developerMessage,
  });
}
