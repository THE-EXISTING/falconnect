import 'package:falconnect/lib.dart';

class ServiceUnavailableException extends ServerErrorException {
  const ServiceUnavailableException({
    super.code = 503,
    super.message,
    super.developerMessage,
    super.errors,
  });
}
