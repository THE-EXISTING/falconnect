import 'package:falconnect/lib.dart';

class ForbiddenException extends ClientErrorException {
  const ForbiddenException({
    super.code = 403,
    super.developerMessage,
    super.message,
    super.errors,
  });
}
