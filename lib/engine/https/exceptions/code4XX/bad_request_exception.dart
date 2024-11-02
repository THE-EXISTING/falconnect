import 'package:falconnect/lib.dart';

class BadRequestException extends ClientErrorException {
  const BadRequestException({
    super.code = 400,
    super.developerMessage,
    super.message,
    super.errors,
  });
}
